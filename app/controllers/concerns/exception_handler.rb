# frozen_string_literal: true

# Handling all exception
module ExceptionHandler
  extend ActiveSupport::Concern

  # Define custom error subclasses - rescue catches `StandardErrors`
  class UploaderError < StandardError; end

  included do
    # Define custom handlers
    rescue_from ActiveRecord::RecordInvalid, with: :four_twenty_two
    rescue_from ExceptionHandler::UploaderError, with: :four_twenty_two
    rescue_from ActiveRecord::RecordNotFound do |e|
      render json: e, status: :not_found
    end
  end

  private

  # JSON response with message; Status code 422 - unprocessable entity
  def four_twenty_two(exception)
    render json: exception, status: :unprocessable_entity
  end
end
