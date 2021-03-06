class RestaurantsController < ApplicationController

  before_action :authenticate_user!, :except => [:index, :show]

  def index
    @restaurants = Restaurant.all
  end

  def new
    @restaurant = Restaurant.new
  end

  def create
    user = current_user
    @restaurant = user.restaurants.build restaurant_params
    if @restaurant.save
      redirect_to restaurants_path
    else
      render 'new'
    end
  end

  def restaurant_params
    params.require(:restaurant).permit(:name)
  end

  def show
    @restaurant = Restaurant.find(params[:id])
  end

  def edit
    @restaurant = Restaurant.find(params[:id])
  end

  def update
    @restaurant = Restaurant.find(params[:id])
    if @restaurant.edit_as current_user
      @restaurant.update(restaurant_params)
    else
      flash[:notice] = 'You can only edit restaurants which you added'
    end
    redirect_to '/restaurants'
  end

  def destroy
    @restaurant = Restaurant.find(params[:id])
    if @restaurant.destroy_as current_user
      flash[:notice] = 'Restaurant deleted successfully'
    else
      flash[:notice] = 'You can only delete restaurants which you added'
    end
    redirect_to '/restaurants'
  end

end
