class Image < ApplicationRecord

  ##
  # Virtual attribute generating the path to the full image file represented by
  # this object.
  #
  def full_path 
    File.join(Rails.application.config.images.upload_directory, id.to_s + extension)
  end

  ##
  # Virtual attribute generating the path to the cropped image file for the
  # image represented by this object.
  #
  def cropped_path 
    File.join(Rails.application.config.images.crop_directory, id.to_s + extension)
  end

end
