require 'usher'

module Rko
  autoload :Dispatcher, 'rko/dispatcher'

  def self.routes
    @routes ||= Usher.new :request_methods => [:request_method, :domain]
  end
end

require 'rko/engine' if defined?(Rails::Engine)
