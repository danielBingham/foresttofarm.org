## 
# Author:: Daniel Bingham <dbingham@theroadgoeson.com>
#
# Handle api requests for Plant images.
class Api::V0::ImagesController < ApplicationController

  ##
  # Retrieve a json list of all images in the database for the given
  # plant.
  #
  # Params::
  # * params[:plant_id] +int+ - The id of the Plant who's Images we want to
  # retrieve.
  #
  # Returns:: +String+  A JSON formatted string representing all the images
  # that belong to the given Plant
  #
  def index
    @images = Image.where('plant_id=?', params[:plant_id]).all

    render :json => @images.to_json(:methods => [:full_path, :cropped_path])
  end

  ##
  # Retrieve details of a single Image in the database.
  #
  # Params:: 
  # * params[:plant_id] +int+ - The id of the Plant who's Image we want to
  # retrieve.
  # * params[:id] +int+  - The id of the Image to retrieve.
  #
  # Returns:: +String+  A JSON formatted representation of the requested Image.  
  #
  def show
    @image = Image.find(params[:id])

    render :json => @image.to_json(:methods => [:full_path, :cropped_path])
  end

  ##
  # Handle requests to upload new images.
  #
  # Params::
  # * params[:plant_id] +int+ - The id of the Plant to add the new Image to.
  # * params[:image]  +IO+  - The uploaded image
  # * params[:attribution]  +String+  - The attribution for the image.
  #
  # Returns:: +String+  A JSON formatted representation of the newly added Image. 
  #
  def create 
    image_service = ImageService.new
    @image = image_service.createFromUploaded(params[:image], params[:attribution])
    if @image == nil
      render  nothing: true, status: :unprocessable_entity
      return
    end

    @image.plant_id = params[:plant_id]
    @image.save

    render :json => @image
  end

  ##
  # Handle requests to update an Image with a new cropped version.
  #
  # Params::
  # * params[:plant_id] +int+ - The id of the Plant the Image belongs to.
  # * params[:id] +int+ - The id of the Image we're going to modify.
  # * params[:width]  +int+ - The width to crop to.
  # * params[:height] +int+ - The height to crop to.
  # * params[:x]  +int+ - The x coordinate of the top left corner of the crop.
  # * params[:y]  +int+ - The y coordinate of the top left corner of the crop.
  #
  # Returns:: nil
  #
  def update 
    image_service = ImageService.new
    
    @image = Image.find(params[:id])

    # TODO validate the crop geometry
    crop_geometry = {
      width: params[:width],
      height: params[:height],
      x: params[:x],
      y: params[:y]
    }
    image_service.crop(@image, crop_geometry)

    render :json => @image
  end

  ##
  # Handle requests to destroy an Image
  #
  # Params::
  # * params[:plant_id] +int+ - The id of the Plant the Image belongs to.
  # * params[:id] +int+ - The id of the Image we're going to destroy
  #
  # Returns:: nil
  #
  def destroy
    image = Image.find(params[:id])
    image.destroy
  end
end
