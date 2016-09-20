class Image < ApplicationRecord

  def getFullPath
    File.join(Rails.application.config.images.upload_directory, id.to_s + extension)
  end

  def getCroppedPath
    File.join(Rails.application.config.images.crop_directory, id.to_s + extension)
  end
end
