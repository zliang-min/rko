# encoding: utf-8

require 'active_support/dependencies/autoload'

require 'sinatra/base'
require 'haml'

module ArticleCollector
  extend ActiveSupport::Autoload

  autoload :Application
  autoload :Models
  autoload :Settings
  autoload :Worker
end
