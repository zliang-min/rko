Rko::Application.routes.draw do
  match '/admin' => "admin/index#index"

  namespace 'admin' do
    resources 'routes'
  end

  match '/(*anything)' => Rko::Dispatcher
end
