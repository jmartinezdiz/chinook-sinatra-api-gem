# frozen_string_literal: true

class ChinookSinatraApi::Persistence::DatabaseNotFoundException < StandardError

  ######################################################
  # VARIABLES
  ######################################################
  attr_reader :file_path

  ######################################################
  # CONSTRUCTOR
  ######################################################
  def initialize(file_path:)
    @file_path = file_path
    super("Not found database file '#{file_path}'")
  end

end
