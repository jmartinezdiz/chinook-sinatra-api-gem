# frozen_string_literal: true

class ChinookSinatraApi::Server::InvalidContentTypeException < StandardError

  ######################################################
  # VARIABLES
  ######################################################
  attr_reader :content_type

  ######################################################
  # CONSTRUCTOR
  ######################################################
  def initialize(content_type:)
    @content_type = content_type
    super("Invalid content_type '#{content_type}' only permitted JSON")
  end

  ######################################################
  # INSTANCE METHODS
  ######################################################
  def http_code
    415
  end

end