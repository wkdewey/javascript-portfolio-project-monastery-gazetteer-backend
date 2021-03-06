class Api::V1::MonasteriesController < ApplicationController

  wrap_parameters :monastery, include: [:name, :location, :religious_tradition, :figure_ids]
  
  def index
    monasteries = Monastery.all
    render json: MonasterySerializer.new(monasteries)
  end

  def show
    monastery = Monastery.find_by(id: params[:id])
    render json: MonasterySerializer.new(monastery)
  end

  def create
    monastery = Monastery.new(monastery_params)
    if monastery.save
      render json: MonasterySerializer.new(monastery), status: :accepted
    else
      render json: { errors: monastery.errors.full_messages }, status: :unprocessible_entity
    end
  end

  def update
    monastery = Monastery.find_by(id: params[:id])
    if params[:image]
      monastery.update(image_params)
    end
    monastery.update(monastery_params)
    if monastery.save
      render json: MonasterySerializer.new(monastery), status: :accepted
    else
      monastery = monastery.find_by(id: params[:id])
      render json: { errors: monastery.errors.full_message }, status: :unprocessible_entity
    end
  end

  def destroy
    monastery = Monastery.find_by(id: params[:id])
    monastery.destroy
    render json: MonasterySerializer.new(monastery)
  end

  private

  def monastery_params
    params.require(:monastery).permit(:name, :location, :religious_tradition, figure_ids: [])
  end

  def image_params
    params.permit(:image, :id)
  end

end