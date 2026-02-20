# frozen_string_literal: true

require 'sinatra/base'

#######################################################
# SERVER
#######################################################
class ChinookSinatraApi::Server < Sinatra::Base

  ######################################################
  # REQUIREMENTS
  ######################################################
  require_relative "exceptions/invalid_content_type_exception"

  ######################################################
  # CONFIG
  ######################################################
  set :host_authorization, { permitted_hosts: [] }
  disable :show_exceptions

  configure do
    enable :logging
    set :persistence, ChinookSinatraApi::Persistence.new(__dir__ + "/resources/chinook.db")
  end

  ######################################################
  # CALLBACKS
  ######################################################
  before do
    content_type :json
    if request.content_type && request.content_type != Rack::Mime.mime_type('.json')
      raise ChinookSinatraApi::Server::InvalidContentTypeException.new(content_type: request.content_type)
    end
  end

  after do
    response.body = JSON.dump(response.body)
  end

  ######################################################
  # ROUTES
  ######################################################
  get '/:table_name' do
    settings.persistence.find_all(params[:table_name])
  end

  get '/:table_name/:id' do
    settings.persistence.find_by_id!(params[:table_name], params[:id])
  end

  post '/:table_name/search_all' do
    parsed_body = body_to_json || {}
    searcher = settings.persistence.searcher_for(
      params[:table_name],
      conditions: (parsed_body["conditions"] || {}),
      orders: (parsed_body["orders"] || []),
      limit: (parsed_body["limit"] || nil),
      offset: (parsed_body["offset"] || nil)
    )
    if searcher.valid?
      searcher.search
    else
      status 422
      { code: 422, errors: searcher.error_messages }
    end
  end

  ######################################################
  # ERRORS
  ######################################################
  error ChinookSinatraApi::Server::InvalidContentTypeException do
    status env['sinatra.error'].http_code
    { code: env['sinatra.error'].http_code, message: env['sinatra.error'].message }
  end

  error ChinookSinatraApi::Persistence::UnsupportedActionException do
    status 400
    { code: 400, message: env['sinatra.error'].message }
  end

  error ChinookSinatraApi::Persistence::TableNotFoundException do
    status 404
    { code: 404, message: env['sinatra.error'].message }
  end

  error ChinookSinatraApi::Persistence::ElementNotFoundException do
    status 404
    { code: 404, message: env['sinatra.error'].message }
  end

  error do
    logger.error(env['sinatra.error'].message)
    { code: 500, message: "Internal server error" }
  end

  ######################################################
  # HELPERS
  ######################################################
  helpers do

    def body_to_json
      request.body.rewind
      body = request.body.read
      JSON.parse(body) if !body.nil? && !body.empty?
    end

  end

end
