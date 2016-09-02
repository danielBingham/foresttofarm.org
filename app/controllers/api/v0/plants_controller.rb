class Api::V0::PlantsController < ApplicationController

    # Retrieve a json list of all plants in the database.
    def index
        @plants = Plant.all

        render :json => @plants
    end

    # Retrieve details of a single plant in the database.
    #
    # * *params*:: 
    #   - +id+ -> The id of the plant to show.
    # * *returns*:: nil
    def show
        @plant = Plant.find(params[:id]).includes(:common_name, :habit, :habitat, :harvest, :drawback, :light_tolerance, :moisture_tolerance, :role, :root_pattern)
    end
end
