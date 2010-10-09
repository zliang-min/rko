# encoding: utf-8

#require 'bundler/setup'
require 'bundler'

begin
  Bundler.setup
rescue Bundler::GemfileNotFound
  if ENV['BUNDLE_GEMFILE']
    raise $!
  else
    ENV['BUNDLE_GEMFILE'] = File.expand_path '../Gemfile', __FILE__
    retry
  end
end

$:.unshift File.expand_path('../app', __FILE__)

require 'article_collector'

Dir[File.expand_path '../init/*.rb', __FILE__].each { |init| require init }
