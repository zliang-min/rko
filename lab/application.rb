# encoding: utf-8

require 'bundler/setup'

require 'sinatra/base'
require 'haml'

#require 'mongorb'

class Application < Sinatra::Base

=begin
  class Route
    include Mongorb::Document

    property :verb,    String, :length => 6
    property :path,    String, :length => 255
    property :options, Hash
  end
=end

  Route.all.each do |route|
  end

  if development?
    reset!
    use Rack::Reloader
  end

  get '/' do
    haml :index
  end

  template :index do
    <<_HAML_
!!! 5
%html(lang="zh")
  %head
    %meta(charset="UTF-8")
    %title IPHONE4
  %body 梁智敏：“iPhone 4 只能算是一台优秀的只能移动设备，而不是一台优秀的手机。”
_HAML_
  end
end
