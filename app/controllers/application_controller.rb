class ApplicationController < ActionController::API
  before_action :check_resource_id, only: [:update]
  
  private
  def check_resource_id
    if (body_id = params.dig(:data, :id)) && body_id.to_i != params[:id].to_i
      raise ArgumentError.new('Resource ids differ in query string and request body')
    end
  end
  
  def render_jsonapi_error_for(resource)
    render json: {
      errors: resource.errors.map do |attr, error|
        {
          status: 422,
          title: attr == :base ? error : "\"#{attr.to_s}\" #{error}"
        }
      end
    }, status: :unprocessable_entity
  end
  
  def render_resource_not_found(klass)
    render json: {
      errors: [
        {
          status: 404,
          title: "#{klass.name} not found"
        }
      ]
    }, status: :not_found
  end
end
