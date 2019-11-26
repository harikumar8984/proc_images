# frozen_string_literal: true

# Handles path for local file OR remote url
module PathHandler
  extend ActiveSupport::Concern
  # handle local as well as remote file
  def get_path(value)
    if uri?(value)
      value
    else
      local_image_path(value)
    end
  end

  def local_image_path(name)
    file = Rails.root.join('uploads', name).to_s
    File.exist?(file) ? file : nil
  end

  # Remote file url
  def uri?(string)
    uri = URI.parse(string)
    %w[http https].include?(uri.scheme)
  rescue URI::BadURIError
    false
  rescue URI::InvalidURIError
    false
  end
end
