# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  get 'welcome/index'

  resources :articles do
    resources :comments
  end

  root 'welcome#index'

  # Custom routes for ActiveAdmin
  get '/submit_order/:id', to: 'admin/orders#submit_order', as: :submit_order
end
