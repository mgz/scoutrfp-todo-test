class Api::V1::TagsController < ApplicationController
  def index
    tags = Tag.all
    render json: tags
  end

  def create
    tag = Tag.new(tag_params)
    tag.save!
    render json: tag
  end

  def update
    tag = Tag.find(params[:id])
    tag.update!(tag_params)
    render json: tag
  end

  private
  def tag_params
    params.require(:data).require(:attributes).permit(:title)
  end
end
