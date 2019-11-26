# frozen_string_literal: true

module Api
  module V1
    # uploading service API
    class ProgImagesController < ApiController
      include PathHandler
      before_action :generate_random_id, only: [:create]

      # POST /prog_images
      def create
        public_ids = []
        params[:file] && params[:file].each do |_key, image|
          if (path = get_path(image))
            ProgImageManager::ImageProcessor.create(public_id: @public_id)
            UploaderJob.perform_async(@public_id, path)
            public_ids << {image => @public_id}
          else
            public_ids << {image =>'File url not found'}
          end
        end
        render json: public_ids , status: :ok
      end

      private

      def generate_random_id
        @public_id = SecureRandom.uuid
      end
    end
  end
end
