# frozen_string_literal: true

# require 'api_constraints'
Rails.application.routes.draw do
  # Api definition
  namespace :api do
    scope module: :v1, constraints: ProgImageManager::ApiConstraints.new(version: 1, default: true) do
      resources :prog_images, only: %i[create], param: :public_id
    end
  end
end
