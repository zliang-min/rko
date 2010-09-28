# encoding: utf-8
require 'bundler/setup'

require 'logger'

require 'sinatra/base'
require 'haml'

require 'active_record'

(ActiveRecord::Base.logger = Logger.new $stdout).level = Logger::DEBUG

module ArticleFilter
  module Models
    class ArticleInfo < ActiveRecord::Base
      establish_connection adapter: 'mysql2',
                           encoding: 'UTF8',
                           reconnect: false,
                           database: '51hejia',
                           pool: 1,
                           host: '192.168.0.14',
                           username: 'hejiasql',
                           password: 'sql2009'

      def added_status
        read_attribute(:added_status) == 1
      end

      def added_status=(added_status)
        write_attribute(:added_status, added_status ? 1 : 0)
      end
    end
  end

  class Application < Sinatra::Base
    include Models

    if development?
      reset!
      use Rack::Reloader
      use Rack::CommonLogger
    end

    set :app_file, __FILE__
    set :app_name, '和家网 - 文章采集管理后台'
    set :per_page, 20

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
