# frozen_string_literal: true

# Uploader Service which communicate with cloudinary API
class UploaderService
  def self.upload(image, public_id)
    Cloudinary::Uploader.upload image, public_id: public_id
  rescue StandardError => e
    raise ExceptionHandler::UploaderError, {error: e.message}
  end
end
