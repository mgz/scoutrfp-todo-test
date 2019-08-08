class Api::V1::TagsController < ApplicationController
  def index
    tags = Tag.all
    render json: tags
  end

  def create
    tag = Tag.new(tag_params)
    if tag.save
      render json: tag
    else
      render_jsonapi_error_for(tag)
    end
  end

  def update
    if (tag = Tag.find_by_id(params[:id]))
      if tag.update(tag_params)
        render json: tag
      else
        render_jsonapi_error_for(tag)
      end
    else
      render json: {
        errors: [
          {
            status: 404,
            title: "Tag not found"
          }
        ]
      }, status: :not_found
    end
  end

  private
  def tag_params
    params.require(:data).require(:attributes).permit(:title)
  end
end
