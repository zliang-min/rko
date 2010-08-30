module Admin
  class Dispatcher
    class << self
      def call(env)
        Rails.logger.info '------>'
        Rails.logger.info env.inspect
        Rails.logger.info '<------'
        if response = Admin.routes.recognize(ActionDispatch::Request.new(env))
          response.destination.call(env)
        else
          raise ActionController::RoutingError, 'OTZ'
        end
      end
    end
  end
end
