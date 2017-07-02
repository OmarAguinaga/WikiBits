Rails.application.routes.draw do

  resources :topics do
     resources :wikis, except: [:index]
   end

   resources :charges, only: [:new, :create]
   delete '/cancel_plan' => 'charges#cancel_plan'


  devise_for :users
  get 'welcome/index'
  root 'welcome#index'


end
