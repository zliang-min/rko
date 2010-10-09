# encoding: utf-8

require 'logger'
require 'active_record'
require 'nokogiri'
require 'resque'

(ActiveRecord::Base.logger = Logger.new $stdout).level = Logger::DEBUG if ENV['RACK_ENV'] == 'development'

module ArticleCollector
  module Models
    class ArticleInfo < ActiveRecord::Base

      establish_connection Settings.database

      INVALID_TAGS  = %w[applet embed form frame frameset input iframe object script select style]
      INVALID_ATTRS = /^on|^(style|id|class)$/i

      STATES = {
        new:        [0, '未收录'],
        processing: [2, '处理中'],
        imported:   [1, '已收录']
      }

      STATES.each do |k, (code, _)|
        define_method("#{k}?") { puts "<=> compare #{added_status.inspect} with #{code.inspect}"; added_status == code }
      end

      def added_status=(added_status)
        status =
          case added_status
          when Integer
            added_status
          when String
            STATES.find { |k, (_, name)| name == added_status }[1][0]
          when Symbol
            STATES[added_status][0]
          end
        write_attribute :added_status, status
      end

      def added_status_name
        STATES.find { |k, (code, _)| code == added_status }[0]
      end

      def added_status_human_name
        STATES.find { |k, (code, _)| code == added_status }[1][1]
      end

      def raw_content
        read_attribute :content
      end

      def sterilized_content
        (h = Nokogiri::HTML::DocumentFragment.parse raw_content).traverse do |node|
          if INVALID_TAGS.include?(node.name)
            node.remove 
            next
          end
          node.attribute_nodes.each do |attr|
            attr.remove if INVALID_ATTRS === attr.name
          end
        end
        h.to_s
      end

      alias content sterilized_content

      def sterilize_content!
        update_attribute :content, sterilized_content
      end

      def import
        update_attribute :added_status, STATES[:processing][0]
        Resque.enqueue Job, id
      end
    end
  end
end
