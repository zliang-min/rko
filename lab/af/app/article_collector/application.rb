# encoding: utf-8

require 'sinatra/base'
require 'haml'

module ArticleCollector
  class Application < Sinatra::Base
    include Models

    if development?
      reset!
      use Rack::Reloader
      use Rack::CommonLogger
    end

    register Settings

    helpers do
      def title
        haml '%h1= settings.app_name ', :layout => false
      end
    end

    get '/' do
      haml :index
    end

    get '/articles/:id' do
      if article = ArticleInfo.where(:id => params[:id]).first
        haml :show_article, :locals => {:article => article}, :layout => false
      else
        halt 404
      end
    end

    get '/articles/:id/import' do
      Worker.new(params[:id]).run!
      ''
    end

    get '/articles' do
      articles = ArticleInfo
      articles = articles.where :added_status => 0 if params[:uo] == 'true'
      if (num = params[:num].to_i) > 0
        articles = articles.where "created_at >= ?", num.send(%w[days weeks months years].include?(params[:unit]) ? params[:unit] : 'days').ago
      end
      articles.include_root_in_json = false

      content_type :json, charset: 'utf-8'
      {
        success: true,
        total: articles.count,
        rows: articles.select('id, title, created_at, added_status').order('created_at DESC').offset(params[:start]).limit(params[:limit])
      }.to_json
    end
  end
end
