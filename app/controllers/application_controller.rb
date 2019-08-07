class ApplicationController < ActionController::API
  before_action :check_resource_id, only: [:update]
  def check_resource_id
    if (body_id = params.dig(:data, :id)) && body_id.to_i != params[:id].to_i
      raise ArgumentError.new('Resource ids differ in query string and request body')
    end
  end
end
