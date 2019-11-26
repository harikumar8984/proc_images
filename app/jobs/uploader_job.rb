# frozen_string_literal: true

# Schedulde job for handling uploading service
class UploaderJob 
  include Sidekiq::Worker
  #queue_as :default

  def perform(public_id, image)
    @uploads = UploaderService.upload(image, public_id)
    @image = ProgImageManager::ImageProcessor.find_by_public_id(public_id)
    @image.update_attributes(proc_params(@uploads)) if @image
  end

  private

  def proc_params(data)
    keys = %w[public_id version format url secure_url original_filename]
    data.select { |x| keys.include?(x.to_s) }
  end
end
