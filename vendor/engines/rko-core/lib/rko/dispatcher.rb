module Rko
  class Dispatcher
    class Processor
      def call(env)

      end
    end

    class << self
      def call(env)
        request = ActionDispatch::Request.new env
        if (response = Rko.routes.recognize(request)).succeeded?
          env['rko.route.params'] = response.params_as_hash
          response.destination[:resource_type].constantize.where(:id => response.destination[:resource_id]).call env
        else
          raise ActionController::RoutingError, "No route matches #{request.path}"
        end
      end

      def add_route(path, options = nil)
        Rko.routes.add_route(path, options).to(Processor)
      end
    end # class << self
  end # Dispatcher
end # Rko
