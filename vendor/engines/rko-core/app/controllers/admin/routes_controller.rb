class Admin::RoutesController < ApplicationController

  def index
    if (name = params[:name]).blank?
      render text: 'Give me a name!'
    else
      Rko.routes.add_route("/#{name}", :conditions => {
        :request_method => 'GET'
      }).to(
        lambda { |env| [200, {'Content-Type' => 'text/html'}, ["#{name} was successfully added!"]] }
      )
      render :text => "#{name}'s done! Now we have #{Rko.routes.route_count} routes in RKO."
    end
  end

end
