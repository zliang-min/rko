class Admin::RoutesController < ApplicationController

  def index
    Admin.routes.add_route('/hello', :conditions => {
      :request_method => 'GET'
    }).to(
      lambda { |env| [200, {'Content-Type' => 'text/html'}, ['Hello was successfully added!']] }
    )
    render :text => "I'm done! Now we have #{Admin.routes.route_count} routes in Admin."
  end

end
