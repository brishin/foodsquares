class RestaurantController < ApplicationController

  # GET /restaurant/status/:id
  def status
    if params[:id]
      @restaurant = Restaurant.first(:nid => params[:id])
      respond_to do |format|
        format.json { render json: @restaurant }
      end
    end
  end
end