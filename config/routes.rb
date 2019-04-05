Rails.application.routes.draw do

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root "links#new"

  resources :links

  match '*path', via: :all, to: 'links#redirect_short_url'

end
