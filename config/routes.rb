require 'sidekiq/web'

Rails.application.routes.draw do
  get '/links' => "links#index", as: :links
  post '/links' => "links#create"
  get '/links/new' => "links#new", as: :new_link
  get '/links/:admin_code/edit' => "links#edit", as: :edit_link
  put '/links/:admin_code' => "links#update", as: :expire_link
  patch '/links/:admin_code' => "links#update"
  delete '/links/:admin_code' => "links#destroy", as: :destroy_link

  get '/logout' => "auths#logout" # above shortcode so it takes precedence because they look the same
  mount Sidekiq::Web => '/sidekiq'
  get '/:short_code' => "links#visit"
  get '/admin/:admin_code' => "links#show", as: :link

  root to: "links#new"
end
