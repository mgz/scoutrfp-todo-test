module RequestSpecHelper
  def json
    JSON.parse(response.body)
  end
  
  def expect_code_200
    expect(response.content_type).to eq("application/json")
    expect(response).to have_http_status(:ok)
  end
  
  def first_json_data
    json['data'][0]
  end
  
  def response_at(path)
    parse_json(response.body, path)
  end
  
  def first_jsonapi_error
    json['errors'].first['title']
  end
end