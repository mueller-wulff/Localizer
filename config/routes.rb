Rails.application.routes.draw do

  get 'sessions/new'
  get 'users/new'
  root 'static_pages#home'
  get 'menu' => 'static_pages#menu'
  get 'impressum' => 'static_pages#impressum'


  resources :apps do
    get 'change_nodes' => 'apps#change_nodes', on: :member
    get 'add_language' => 'apps#add_language', on: :member
    post 'add_additional_file' => 'apps#add_additional_file', on: :member
    get 'export_file' => 'apps#export_file', on: :member
  end

  resources :nodes do
  end

  resources :collaborations do
    get 'change_nodes' => 'collaborations#change_nodes', on: :member
  end

  resources :users do
  end

  get    'signup'  => 'users#new'
  get    'login'   => 'sessions#new'
  post   'login'   => 'sessions#create'
  delete 'logout'  => 'sessions#destroy'
  post    'set_free' => 'languages#set_free'
  post    'set_un_free' => 'languages#set_un_free'

end
