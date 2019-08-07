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

  private
  def tag_params
    params.require(:data).require(:attributes).permit(:title)
  end
end
