require 'usher'

module Admin
  autoload :Dispatcher, 'admin/dispatcher'

  def self.routes
    @routes ||= Usher.new :request_methods => [:request_method, :domain]
  end
end

require 'admin/engine' if defined?(Rails::Engine)
