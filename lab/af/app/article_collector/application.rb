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
      puts '-' * 30
      puts "reload_templates? #{settings.reload_templates} ( #{settings.development?} )"
      haml :index
    end

    get '/articles/:id' do
      if article = ArticleInfo.where(:id => params[:id]).first
        haml :show_article, :locals => {:article => article}, :layout => false
      else
        halt 404
      end
    end

    post '/articles/:id/import' do
      article = ArticleInfo.select('id, added_status').where(id: params[:id]).first

      unless article.new?
        content_type :json, charset: 'utf-8'
        halt [403, {message: '此文章已被收录或者正被处理中。'}.to_json] 
      end

      article.import 
      202
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
      }.to_json(:methods => [:added_status_human_name, :added_status_name], :except => :added_status)
    end
  end
end
