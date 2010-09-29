# encoding: utf-8

require 'logger'
require 'active_record'

(ActiveRecord::Base.logger = Logger.new $stdout).level = Logger::DEBUG

module ArticleCollector
  module Models
    class ArticleInfo < ActiveRecord::Base
      establish_connection Settings.database

      def added_status
        read_attribute(:added_status) == 1
      end

      def added_status=(added_status)
        write_attribute(:added_status, added_status ? 1 : 0)
      end
    end
  end
end
