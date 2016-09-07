class Api::V0::PlantsController < ApplicationController

    # Retrieve a json list of all plants in the database.
    def index
      @plants = Plant.includes(:common_names).all

        render :json => @plants, :include => { :common_names =>{} }
    end

    # Retrieve details of a single plant in the database.
    #
    # * *params*:: 
    #   - +id+ -> The id of the plant to show.
    # * *returns*:: nil
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
