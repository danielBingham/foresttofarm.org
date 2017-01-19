class Api::V0::PlantsController < ApplicationController

  ##
  # Retrieve a json list of all plants in the database.
  #
  # Renders:: +String+  A JSON formatted representation of all Plant objects in
  # the database with their associated CommonNames.
  #
  def index
    @plants = Plant.includes(:common_names).all

    render :json => @plants, :include => { :common_names =>{} }
  end

  # Retrieve details of a single plant in the database.
  #
  # Params:: 
  # * params[:id]  +int+ -  The id of the plant to show.
  #
  # Renders:: A JSON formatted representation of the requested Plant object
  # with all child associations. 
  #
  def show
    @plant = Plant.includes(
      :common_names, :harvests, :drawbacks, :habits, 
      :habitats, :light_tolerances, :moisture_tolerances, 
      :roles, :root_patterns).find(params[:id])

    render :json => @plant, :include => [
      :common_names, :harvests, :drawbacks, :habits, 
      :habitats, :light_tolerances, :moisture_tolerances, 
      :roles, :root_patterns]
  end
end
