# encoding: utf-8

require 'nokogiri'

module ArticleCollector
  class Worker
    include Models

    def initialize(article_id)
      @article_id = article_id
    end

    def run!
      article = ArticleInfo.find(@article_id)
      content = Nokogiri::HTML article.content
      content.css('img').each do |image|
        puts image
      end
      content.css('script').each { |tag| }
    end
  end
end
