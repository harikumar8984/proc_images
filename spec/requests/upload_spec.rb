# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Uploading service', type: :request do
  let!(:random_id) { SecureRandom.uuid }
  # Test suite for POST api/prog_images/
  describe 'POST api/prog_images' do

    let(:valid_attributes_1) { { 'file[0]' => "test1.png"} }
    let(:valid_attributes_2) { { 'file[0]' => "https://homepages.cae.wisc.edu/~ece533/images/cat.png"} }
    let(:in_valid_attributes) { { 'file[0]' => "invalid.png"} }
    let(:mix_attributes) { { 'file[0]' => "invalid.png", 'file[1]' => "test1.png"} }

    it 'Image uploading via file Repository' do
      post  "/api/prog_images/", params: valid_attributes_1
      expect(response).to have_http_status(200)
      expect(json).not_to be_empty
      expect(json.size).to eq(1)
      Sidekiq::Worker.drain_all
      expect(UploaderJob.jobs.size).to eq(0)
      @image = ProgImageManager::ImageProcessor.find_by_public_id(json[0]["test1.png"])
      expect(@image).not_to be_nil
      expect(@image.original_filename).to eq("test1")
      expect(@image.format).to eq("png")
    end

    it 'Image uploading via Remote url' do
      post  "/api/prog_images/", params: valid_attributes_2
      expect(response).to have_http_status(200)
      expect(json).not_to be_empty 
      expect(json.size).to eq(1)
      Sidekiq::Worker.drain_all
      expect(UploaderJob.jobs.size).to eq(0)
      @image = ProgImageManager::ImageProcessor.find_by_public_id(json[0]["https://homepages.cae.wisc.edu/~ece533/images/cat.png"])
      expect(@image).not_to be_nil
      expect(@image.original_filename).to eq("cat")
      expect(@image.format).to eq("png")
    end

    it 'Ensure sidekiq job is enqued in correct queue for uploading' do
      post  "/api/prog_images/", params: valid_attributes_1
      assert_equal "default", UploaderJob.queue
      expect(UploaderJob.jobs.size).to eq(1)
      expect(UploaderJob).to be_processed_in :default
      expect(UploaderJob).to have_enqueued_sidekiq_job(json[0]["test1.png"], "/prog_image/uploads/#{valid_attributes_1['file[0]']}")
    end

    it 'Trying to upload file which is not exist' do
      post  "/api/prog_images/", params: in_valid_attributes
      expect(json).not_to be_empty
      expect(json.count).to eq(1)
      expect(json[0]["invalid.png"]).to eq("File url not found")
    end


    it 'Trying to upload valid as well as invalid file path' do
      post  "/api/prog_images/", params: mix_attributes
      expect(json).not_to be_empty
      expect(json).not_to be_nil
      expect(json.count).to eq(2)
      expect(json[0]["invalid.png"]).to eq("File url not found")
      expect(UploaderJob.jobs.size).to eq(1)
      Sidekiq::Worker.drain_all
      expect(UploaderJob.jobs.size).to eq(0)
      @image = ProgImageManager::ImageProcessor.find_by_public_id(json[1]["test1.png"])
      expect(@image).not_to be_nil
      expect(@image.original_filename).to eq("test1")
      expect(@image.format).to eq("png")
    end
  end
end
