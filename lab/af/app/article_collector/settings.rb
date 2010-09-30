# encoding: utf-8

module ArticleCollector
  module Settings
    class << self
      def settings
        {
          root:     File.expand_path('../../..', __FILE__),
          app_name: '和家网 - 文章采集管理后台',

          per_page: 20,

          :enviroments => {
            :development => {
            }
          },
          ext_dns: [nil, :development, :test].include?(ENV['RACK_ENV']) ? nil : 'http://extjs.cachefly.net',
          database: {
            adapter: 'mysql2',
            encoding: 'UTF8',
            reconnect: false,
            database: '51hejia_spider',
            pool: 1,
            host: '192.168.0.13',
            username: '51hejia',
            password: 'ruby'
          }
        }
      end

      def registered(app)
        settings = self.settings
        app.class_eval { set settings }
      end

      private

      def method_missing(m, *args, &b)
        settings.has_key?(m) ? settings[m] : super
      end
    end
  end
end

