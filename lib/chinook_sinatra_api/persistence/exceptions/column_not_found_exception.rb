# frozen_string_literal: true

class ChinookSinatraApi::Persistence::ColumnNotFoundException < StandardError

  ######################################################
  # VARIABLES
  ######################################################
  attr_reader :column_names

  ######################################################
  # CONSTRUCTOR
  ######################################################
  def initialize(column_names:)
    @column_names = column_names
    @column_names.size > 1 ?
      super("Not found columns #{@column_names.map{|x| "'#{x}'"}.join(", ")}") :
      super("Not found column '#{@column_names.first}'")
  end

end
