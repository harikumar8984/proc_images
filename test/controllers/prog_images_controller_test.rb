# frozen_string_literal: true

require 'test_helper'

class ProgImagesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @prog_image = prog_images(:one)
  end

  test 'should get index' do
    get prog_images_url, as: :json
    assert_response :success
  end

  test 'should create prog_image' do
    assert_difference('ProgImage.count') do
      post prog_images_url, params: { prog_image: {} }, as: :json
    end

    assert_response 201
  end

  test 'should show prog_image' do
    get prog_image_url(@prog_image), as: :json
    assert_response :success
  end

  test 'should update prog_image' do
    patch prog_image_url(@prog_image), params: { prog_image: {} }, as: :json
    assert_response 200
  end

  test 'should destroy prog_image' do
    assert_difference('ProgImage.count', -1) do
      delete prog_image_url(@prog_image), as: :json
    end

    assert_response 204
  end
end
