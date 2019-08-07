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
      render json: {
        errors: tag.errors.map do |attr, error|
          {
            status: 422,
            title: "\"#{attr.to_s}\" #{error}"
          }
        end
      }, status: :unprocessable_entity
    end
  end

  def update
    if (tag = Tag.find_by_id(params[:id]))
      if tag.update(tag_params)
        render json: tag
      else
        render json: {
          errors: tag.errors.map do |attr, error|
            {
              status: 422,
              title: "\"#{attr.to_s}\" #{error}"
            }
          end
        }, status: :unprocessable_entity
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
