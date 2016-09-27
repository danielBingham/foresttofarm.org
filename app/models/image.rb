class Image < ApplicationRecord

  ##
  # Virtual attribute generating the path to the full image file represented by
  # this object.
  #
  def full_path 
    File.join(Rails.application.config.images.full_path_root, id.to_s + extension)
  end

  ##
  # Virtual attribute generating the path to the cropped image file for the
  # image represented by this object.
  #
  def cropped_path 
    File.join(Rails.application.config.images.crop_path_root, id.to_s + extension)
  end

  ##
  # Virtual attribute generating the path to the full image file represented by
  # this object.
  #
  def full_directory
    File.join(Rails.application.config.images.upload_directory, id.to_s + extension)
  end

  ##
  # Virtual attribute generating the path to the cropped image file for the
  # image represented by this object.
  #
  def cropped_directory
    File.join(Rails.application.config.images.crop_directory, id.to_s + extension)
  end
end
