Rails.application.routes.draw do

  resources :topics do
     resources :wikis, except: [:index]
   end


  devise_for :users
  get 'welcome/index'
  root 'welcome#index'


end
