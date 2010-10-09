# encoding: utf-8

require 'fileutils'
require 'nokogiri'

module ArticleCollector
  class Job
    include Models

    @queue = :import_queue

    def self.perform(article_id)
      FileUtils.mkdir_p '/tmp/af/'
      File.open("/tmp/af/#{article_id}.log", 'w') do |file|
        article = ArticleInfo.find(article_id)
        file << "= Title =\n"
        file << article.title
        file << "\n\n"
        file << "= Images =\n"
        Nokogiri::HTML::DocumentFragment.parse(article.content).css('img').each do |image|
          file << image['src']
          file << "\n"
        end
      end
    rescue
      File.open('/tmp/af.log', 'a') { |f| f << $!.message; f << "\n"; f << $@.join("\n"); f << "\n\n" }
    end
  end
end
