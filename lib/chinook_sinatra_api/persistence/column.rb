# frozen_string_literal: true

######################################################
# COLUMN
######################################################
class ChinookSinatraApi::Persistence::Column

  ######################################################
  # VARIABLES
  ######################################################
  attr_reader :name
  attr_reader :type
  attr_reader :primary_key

  ######################################################
  # CONSTRUCTOR
  ######################################################
  def initialize(name:, type:, primary_key:)
    @name = name
    @type = type
    @primary_key = primary_key
  end

  ######################################################
  # PUBLIC INSTANCE METHODS
  ######################################################
  def primary_key?
    primary_key == 1
  end

end
