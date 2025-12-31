# frozen_string_literal: true

require_relative "chinook_sinatra_api/version"

module ChinookSinatraApi

  ######################################################
  # REQUIREMENTS
  ######################################################
  require_relative "chinook_sinatra_api/persistence/persistence"
  require_relative "chinook_sinatra_api/server/server"
  require_relative "chinook_sinatra_api/utils/string"

end
