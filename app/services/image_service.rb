##
# Author:: Daniel Bingham <dbingham@theroadgoeson.com>
# License:: MIT
#
# Class to handle Image uploads and manipulation.  Provides
# methods for moving uploaded images to the proper location
# and performing image cropping.
#
class ImageService

  ##
  # Move a newly uploaded image to the proper storage location and create the
  # Image model to represent it.
  #
  # Params::
  # * uploaded_image  +IO+  The uploaded image object.
  # * attribution +String+  The image's attribution.
  #
  # Returns:: +Image+ The Image model representing the newly uploaded image or
  # +nil+ if the image isn't valid.
  #
  def createFromUploaded(uploaded_image, attribution)
    extension = File.extname(uploaded_image.original_filename)
    
    image = Image.create(attribution: attribution, extension: extension)

    File.open(image.full_directory, 'wb') do |file|
      file.write(uploaded_image.read)
    end

    image_magick = MiniMagick::Image.open(image.full_directory) 
    image.width = image_magick.width
    image.height = image_magick.height
    image.save

    return image
  end

  ##
  # Crop an image to the specified dimensions and size.
  #
  # Params::
  # * image +Image+ The image we want to crop.
  # * crop_geometry +Hash+  A hash containing the dimensions of the area we want
  # to crop to. Has structure:
  #   - x +int+ The x coordinate of the top left corner of the crop to region.
  #   - y +int+ The y coordinate of the top left corner of the crop to region.
  #   - width +int+ The width of the crop to region.
  #   - height  +int+ The height of the crop to region.
  #
  # Returns:: +Image+ The model for the cropped image.
  #
  def crop(image, crop_geometry)
    cropped_image = MiniMagick::Image.open(image.full_directory)

    crop_geometry_string = "#{crop_geometry.width}x#{crop_geometry.height}+#{crop_geometry.x}+#{crop_geometry.y}"
    cropped_image.crop(crop_geometry_string)

    cropped_image.write(image.cropped_directory)
    return image
  end
end
