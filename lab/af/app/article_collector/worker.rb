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
      content = Nokogiri::HTML ariticle.content
      puts "== links"
      content.css('a').each do |link|
        puts link
      end
    end
  end
end
