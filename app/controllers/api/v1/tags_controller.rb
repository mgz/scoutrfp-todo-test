class Api::V1::TagsController < ApplicationController
  rescue_from ActiveRecord::RecordNotUnique, with: :render_record_not_unique
  
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
  
  def render_record_not_unique
    render json: {
      errors: [
        {
          status: 422,
          title: "Tag is not unique"
        }
      ]
    }, status: :unprocessable_entity
  end
end
