# frozen_string_literal: true

class ChinookSinatraApi::Persistence::TableNotFoundException < StandardError

  ######################################################
  # VARIABLES
  ######################################################
  attr_reader :table_name

  ######################################################
  # CONSTRUCTOR
  ######################################################
  def initialize(table_name:)
    @table_name = table_name
    super("Not found table '#{table_name}'")
  end

end
