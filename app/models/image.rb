class Image < ApplicationRecord

  def getFullPath
    File.join(Rails.application.config.images.upload_directory, id + extension)
  end

  def getCroppedPath
    File.join(Rails.application.config.images.crop_directory, id + extension)
  end
end
