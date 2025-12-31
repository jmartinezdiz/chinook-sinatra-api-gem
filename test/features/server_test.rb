# frozen_string_literal: true

require "test_helper"

class ChinookSinatraApiServerTest < BaseTest
  include Rack::Test::Methods

  def app
    ChinookSinatraApi::Server
  end

  def test_valid_content_type
    # Valid implicit request
    get '/media_types'
    assert last_response.ok?
    # Valid explicit request
    get '/media_types', nil, 'CONTENT_TYPE' => 'application/json'
    assert last_response.ok?
    # Invalid explicit request
    get '/media_types', nil, 'CONTENT_TYPE' => 'text/html'
    assert !last_response.ok?
    assert_equal last_response.status, 415
  end

  def test_find_all_data
    # Valid request
    get '/media_types'
    assert last_response.ok?
    data = JSON.parse(last_response.body)
    db_data = db_connection.execute("SELECT * FROM media_types")
    assert data.is_a?(Array)
    assert_equal data.count, db_data.count
    assert data.each_with_index.all?{|x, index| x.values == db_data[index]}
    # Valid request with table_name in other format
    get '/MediaTypes'
    assert last_response.ok?
    # Invalid request
    get '/invalid_database'
    assert !last_response.ok?
    assert last_response.status, 404
  end

  def test_find_by_id_data
    # Valid request
    get '/media_types/1'
    assert last_response.ok?
    data = JSON.parse(last_response.body)
    db_data = db_connection.execute("SELECT * FROM media_types WHERE MediaTypeId = 1")
    assert data.is_a?(Hash)
    assert data.values == db_data.first
    # Valid request with table_name in other format
    get '/MediaTypes/1'
    assert last_response.ok?
    # Invalid request id
    get '/media_types/invalid_id'
    assert !last_response.ok?
    assert last_response.status, 404
    # Invalid request database
    get '/invalid_database/1'
    assert !last_response.ok?
    assert last_response.status, 404
  end

  def test_search
    # Valid empty body request
    post '/customers/search_all', nil, 'CONTENT_TYPE' => 'application/json'
    assert last_response.ok?
    data = JSON.parse(last_response.body)
    db_data = db_connection.execute("SELECT * FROM customers")
    assert data.is_a?(Array)
    assert_equal data.count, db_data.count
    assert data.each_with_index.all?{|x, index| x.values == db_data[index]}
    # Valid full body request
    body = {
      conditions: { CustomerId: 1, Country: "Brazil" },
    }
    post '/customers/search_all', body.to_json, 'CONTENT_TYPE' => 'application/json'
    assert last_response.ok?
    data = JSON.parse(last_response.body)
    db_data = db_connection.execute("SELECT * FROM customers WHERE CustomerId = 1 AND Country = 'Brazil'")
    assert data.is_a?(Array)
    assert_equal data.count, db_data.count
    assert data.each_with_index.all?{|x, index| x.values == db_data[index]}
    # Valid request with table_name in other format
    body = {
      conditions: { customerId: 1, country: "Brazil" },
    }
    post '/customers/search_all', body.to_json, 'CONTENT_TYPE' => 'application/json'
    assert last_response.ok?
    assert data.is_a?(Array)
    assert_equal data.count, db_data.count
    assert data.each_with_index.all?{|x, index| x.values == db_data[index]}
    # Invalid request body
    body = {
      conditions: { InvalidColumn: 1 },
    }
    post '/customers/search_all', body.to_json, 'CONTENT_TYPE' => 'application/json'
    assert !last_response.ok?
    assert last_response.status, 422
    # Invalid request database
    get '/invalid_database/search_all'
    assert !last_response.ok?
    assert last_response.status, 404
  end

end
