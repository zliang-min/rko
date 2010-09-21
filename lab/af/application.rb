# encoding: utf-8
require 'bundler/setup'

require 'active_support/json'

require 'sinatra/base'
require 'haml'

require 'active_record'

# ActiveRecord::Base.include_root_in_json = false

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
    end
  end

  class Application < Sinatra::Base
    include Models

    if development?
      reset!
      use Rack::Reloader
    end

    set :app_file, __FILE__
    set :app_name, '和家网 - 文章采集管理后台'

    layout do
    #%link(rel="stylesheet" type="text/css" href="http://extjs.cachefly.net/ext-3.2.1/resources/css/ext-all.css")
    #%script(type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/jquery/1.4.2/jquery.min.js")
    #%script(type="text/javascript" src="http://extjs.cachefly.net/ext-3.2.1/adapter/jquery/ext-jquery-adapter.js")
    #%script(type="text/javascript" src="http://extjs.cachefly.net/ext-3.2.1/ext-all-debug.js")

<<_HAML_
%html
  %head
    %meta(http-equiv="Content-Type" content="text/html; charset=utf-8")
    %title(id="title")= settings.app_name
    / ** CSS **
    / base library
    %link(rel="stylesheet" type="text/css" href="/ext-3.2.1/resources/css/ext-all.css")

    / overrides to base library
    / ++ nothing yet ++

    / ** Javascript **
    / ExtJS library: jquery/adapter
    %script(type="text/javascript" src="/jquery.min.js")
    %script(type="text/javascript" src="/ext-3.2.1/adapter/jquery/ext-jquery-adapter.js")

    / ExtJS library: all widgets
    %script(type="text/javascript" src="/ext-3.2.1/ext-all-debug.js")

    / overrides to base library
    / ++ nothing yet ++

    / extensions
    / ++ nothing yet ++

    / page specific
    :javascript
      Ext.BLANK_IMAGE_URL = 'http://extjs.cachefly.net/ext-3.2.1/resources/images/default/s.gif';
      $(function() {
        \#{yield}
      });
  %body
_HAML_
    end

    template :index do
<<_HAML_
:plain
  new Ext.Viewport(
    \#{cf_object.to_json}
  );
_HAML_
    end

    helpers do
      def js(script)
        ActiveSupport::JSON::Variable.new script
      end

      def title
        haml '%h1= settings.app_name ', :layout => false
      end

      def viewport_config
        {
          layout: 'border',
          items: [{
            region: 'north',
            xtype: 'box',
            height: 27,
            margins: {top: 5, left: 5},
            autoEl: {
              tag: 'div',
              html: title
            }
          }, {
            region: 'center',
            xtype: 'grid',
            store: {
              xtype: 'jsonstore',
              autoDestroy: true,
              fields: ['id', 'title', 'image', 'created_at', 'status'],
              url: '/articles',
              autoLoad: true
            },
            colModel: js("new Ext.grid.ColumnModel({
              defaults: {editable: false, menuDisabled: true},
              columns: [
                {header: 'ID',       dataIndex: 'id',           width: 50, sortable: true},
                {header: '标题',     dataIndex: 'title',        width: 300},
                {header: '图片',     dataIndex: 'image',        width: 100},
                {header: '采集日期', dataIndex: 'created_at',   width: 100} //, xtype: 'datecolumn', format: 'Y年m月d日'},
                {header: '收录状态', dataIndex: 'added_status', width: 50}
              ]
            })"),
            sm: js("new Ext.grid.RowSelectionModel({singleSelect:true})"),
            viewConfig: {
              forceFit: true
            }
          }]
        }
      end
    end

    get '/' do
      haml :index, locals: { cf_object: viewport_config }
    end

    get '/articles' do
      'application/json'
      articles = ArticleInfo.limit(15).order('id DESC')
      articles.include_root_in_json = false
      articles.to_json
    end
  end
end
