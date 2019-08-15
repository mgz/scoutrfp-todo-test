class ApplicationController < ActionController::API
  before_action :check_resource_id, only: [:update]

  rescue_from ActiveRecord::RecordInvalid, with: :render_jsonapi_error
  rescue_from ActiveRecord::RecordNotFound, with: :render_resource_not_found
  
  private
  def check_resource_id
    if (body_id = params.dig(:data, :id)) && body_id.to_i != params[:id].to_i
      raise ArgumentError.new('Resource ids differ in query string and request body')
    end
  end
  
  def render_jsonapi_error(exception)
    render json: {
      errors: exception.record.errors.map do |attr, error|
        {
          status: 422,
          title: generate_error_title(attr, error)
        }
      end
    }, status: :unprocessable_entity
  end
  
  def generate_error_title(attr, error)
    attr == :base ? error : "\"#{attr.to_s}\" #{error}"
  end
  
  def render_resource_not_found
    render json: {
      errors: [
        {
          status: 404,
          title: "#{guess_model_from_controller} not found"
        }
      ]
    }, status: :not_found
  end
  
  def guess_model_from_controller
    controller_name.singularize.capitalize
  end
end
