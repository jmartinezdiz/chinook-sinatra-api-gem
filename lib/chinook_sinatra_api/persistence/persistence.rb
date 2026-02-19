# frozen_string_literal: true

require "sqlite3"

######################################################
# PERSISTENCE
######################################################
class ChinookSinatraApi::Persistence

  ######################################################
  # REQUIREMENTS
  ######################################################
  require_relative "column"
  require_relative "exceptions/column_not_found_exception"
  require_relative "exceptions/database_not_found_exception"
  require_relative "exceptions/element_not_found_exception"
  require_relative "exceptions/table_not_found_exception"
  require_relative "exceptions/unsupported_action_exception"
  require_relative "searcher"
  require_relative "table"

  ######################################################
  # VARIABLES
  ######################################################
  attr_reader :tables

  ######################################################
  # CONSTRUCTOR
  ######################################################
  def initialize(file_path)
    @connection = SQLite3::Database.open(file_path, readonly: true)
    @tables = @connection.execute("PRAGMA table_list").inject({}) do |tables, info|
      tables[info[1]] = ChinookSinatraApi::Persistence::Table.new(connection: @connection, name: info[1])
      tables
    end
  rescue SQLite3::CantOpenException
    raise ChinookSinatraApi::Persistence::DatabaseNotFoundException.new(file_path: file_path)
  end

  ######################################################
  # INSTANCE PUBLIC METHODS
  ######################################################
  def find_all(table_name)
    find_table!(table_name).all
  end

  def find_by_id(table_name, id)
    find_table!(table_name).find_by_id(id)
  end

  def find_by_id!(table_name, id)
    find_table!(table_name).find_by_id!(id)
  end

  def searcher_for(table_name, conditions: {}, orders: [], limit: nil, offset: nil)
    find_table!(table_name).new_searcher(conditions: conditions, orders: orders, limit: limit, offset: offset)
  end

  ######################################################
  # INSTANCE PRIVATE METHODS
  ######################################################
  private

  def find_table!(table_name)
    table = @tables[ChinookSinatraApi::Utils::String.underscore(table_name)]
    raise ChinookSinatraApi::Persistence::TableNotFoundException.new(table_name: table_name) unless table
    table
  end

end
