class Image < ApplicationRecord

  def fullPath
    File.join(Rails.application.config.images.upload_directory, id + extension)
  end

  def croppedPath
    File.join(Rails.application.config.images.crop_directory, id + extension)
  end
end
