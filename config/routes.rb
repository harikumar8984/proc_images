# frozen_string_literal: true

require 'sidekiq/web'

# require 'api_constraints'
Rails.application.routes.draw do
  mount Sidekiq::Web => '/jobs'
  # Api definition
  namespace :api do
    scope module: :v1, constraints: ProgImageManager::ApiConstraints.new(version: 1, default: true) do
      resources :prog_images, only: %i[create], param: :public_id
    end
  end
end
