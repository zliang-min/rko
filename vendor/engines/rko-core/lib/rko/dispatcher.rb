module Rko
  class Dispatcher
    class << self
      def call(env)
        if response = Rko.routes.recognize(ActionDispatch::Request.new(env))
          response.destination.call(env)
        else
          raise ActionController::RoutingError, "No route matches #{env['PATH_INFO']}"
        end
      end
    end
  end
end
