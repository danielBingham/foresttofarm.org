## 
# Author:: Daniel Bingham <dbingham@theroadgoeson.com>
#
# Handle api requests for Plant images.
class Api::V0::ImagesConroller < ApplicationController

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
  end

  ##
  # Handle requests to upload new images.
  #
  # Params::
  # * params[:plant_id] +int+ - The id of the Plant to add the new Image to.
  #
  # Returns:: +String+  A JSON formatted representation of the newly added Image. 
  #
  def create 
  end

  ##
  # Handle requests to update an Image with a new cropped version.
  #
  # Params::
  # * params[:plant_id] +int+ - The id of the Plant the Image belongs to.
  # * params[:id] +int+ - The id of the Image we're going to modify.
  #
  # Reutrns:: nil
  #
  def update 
  end
end
