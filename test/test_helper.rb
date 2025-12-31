# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path("../lib", __dir__)

require "rack/test"
require "minitest/autorun"
require "awesome_print"
require "byebug"

require "chinook_sinatra_api"

class BaseTest < Minitest::Test

  ######################################################
  # INSTANCE PRIVATE METHODS
  ######################################################
  private

  def db_connection
    @db_connection ||= SQLite3::Database.open(__dir__ + "/../lib/chinook_sinatra_api/server/resources/chinook.db", readonly: true)
  end

end
