# frozen_string_literal: true

######################################################
# TABLE
######################################################
class ChinookSinatraApi::Persistence::Table

  ######################################################
  # VARIABLES
  ######################################################
  attr_reader :name
  attr_reader :columns

  ######################################################
  # CONSTRUCTOR
  ######################################################
  def initialize(connection: connection, name: name)
    @connection = connection
    @name = name
    @columns = connection.execute("SELECT name, type, pk FROM pragma_table_info('#{name}')").inject({}) do |acc, info|
      acc[info[0]] = ChinookSinatraApi::Persistence::Column.new(
        name: info[0],
        type: info[1],
        primary_key: info[2]
      )
      acc
    end
  end

  ######################################################
  # PUBLIC INSTANCE METHODS
  ######################################################
  def has_column?(column_name)
    @columns.keys.include?(column_name)
  end

  def all(column_names: self.column_names, conditions: {}, orders: [], limit: nil, offset: nil)
    sql = "SELECT #{column_names.join(",")} FROM #{@name}"
    params = []

    if conditions.any?
      sql << " WHERE "
      sql << conditions.map{|column_name, *| "(#{column_name} = ?)"}.join(" AND ")
      params << conditions.map{|*, column_value| column_value}
    end

    if orders.any?
      sql << " ORDER BY "
      sql << orders.map do |order|
        order.map{|k, v| "#{k} #{v}"}.join(", ")
      end.join(", ")
    end

    if limit
      sql << " LIMIT #{limit}"
    end

    if offset
      sql << " OFFSET #{offset}"
    end

    to_data(column_names, @connection.execute(sql, params))
  end

  def find_by_id(id)
    primary_key_names = self.primary_key_names
    if primary_key_names.size != 1
      raise ChinookSinatraApi::Persistence::UnsupportedActionException.new("Unsupported table for find by primary key")
    end
    all(conditions: { primary_key_names[0] => id }).first
  end

  def find_by_id!(id)
    element = find_by_id(id)
    raise ChinookSinatraApi::Persistence::ElementNotFoundException unless element
    element
  end

  def new_searcher(conditions: {}, orders: [], limit: nil, offset: nil)
    ChinookSinatraApi::Persistence::Searcher.new(table: self, conditions: conditions, orders: orders, limit: limit, offset: offset)
  end

  ######################################################
  # PRIVATE INSTANCE METHODS
  ######################################################
  private

  def to_data(column_names, rows)
    rows.map do |row|
      column_names.each_with_index.inject({}) do |acc, (column_name, index)|
        acc[column_name] = row[index]
        acc
      end
    end
  end

  def column_names
    @columns.keys
  end

  def primary_key_names
    @columns.select{|*, column| column.primary_key?}.keys
  end

end
