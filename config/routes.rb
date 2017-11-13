Rails.application.routes.draw do

  devise_for :users, skip: [:registrations, :sessions]

  as :user do
    post '/users/sign_up', to: 'authorize/registrations#create'
    post '/users/sign_in', to: 'authorize/sessions#create'
    delete '/users/sign_out', to: 'authorize/sessions#destroy'
  end

  resources :issues, only: [:index, :create, :update, :destroy] do
    member do
      patch :in_progress
      patch :resolved
      patch :assign
      patch :unassign
    end
  end
end
