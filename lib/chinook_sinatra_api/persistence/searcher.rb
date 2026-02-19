# frozen_string_literal: true

######################################################
# SEARCHER
######################################################
class ChinookSinatraApi::Persistence::Searcher

  ######################################################
  # CONSTRUCTOR
  ######################################################
  def initialize(table:, conditions: {}, orders: [], limit: nil, offset: nil)
    @table = table
    @conditions = to_conditions(conditions)
    @orders = to_orders(orders)
    @limit = limit
    @offset = offset
    @errors = calculate_errors
  end

  ######################################################
  # PUBLIC INSTANCE METHODS
  ######################################################
  def search
    @table.all(conditions: @conditions, orders: @orders, limit: @limit, offset: @offset)
  end

  def valid?
    @errors.size == 0
  end

  def error_messages
    @errors.map{|x| x[:message] || x[:exception].message}
  end

  ######################################################
  # PRIVATE INSTANCE METHODS
  ######################################################
  private

  def to_conditions(conditions)
    if conditions.is_a?(Hash)
      conditions.inject({}) do |acc, (column_name, column_value)|
        key = column_name.is_a?(String) || column_name.is_a?(Symbol) ?
          ChinookSinatraApi::Utils::String.upper_camelize(column_name.to_s) :
          column_name
        acc[key] = column_value
        acc
      end
    else
      conditions
    end
  end

  def to_orders(orders)
    if orders.is_a?(Array)
      orders.map do |order|
        if order.is_a?(Hash)
          order.inject({}) do |acc, (column_name, column_value)|
            key = column_name.is_a?(String) || column_name.is_a?(Symbol) ?
              ChinookSinatraApi::Utils::String.upper_camelize(column_name.to_s) :
              column_name
            acc[key] = column_value
            acc
          end
        else
          order
        end
      end
    else
      orders
    end
  end

  def calculate_errors
    errors = []
    unless @conditions.is_a?(Hash)
      errors << {
        exception: ChinookSinatraApi::Persistence::UnsupportedActionException.new("Conditions must be a Hash"),
      }
    else
      if @conditions.any?{|column_name, *| !column_name.is_a?(String) && !column_name.is_a?(Symbol)}
        errors << {
          exception: ChinookSinatraApi::Persistence::UnsupportedActionException.new("Conditions keys must be a String"),
        }
      end
      if (invalid_column_names = @conditions.select{|column_name, *| !@table.has_column?(column_name)}.keys).any?
        errors << {
          exception: ChinookSinatraApi::Persistence::ColumnNotFoundException.new(column_names: invalid_column_names),
        }
      end
    end

    if !@orders.is_a?(Array)
      errors << {
        exception: ChinookSinatraApi::Persistence::UnsupportedActionException.new("Orders must be a Array"),
      }
    else
      @orders.each do |order|
        if !order.is_a?(Hash)
          errors << {
            exception: ChinookSinatraApi::Persistence::UnsupportedActionException.new("All orders must be a Hash"),
          }
        else
          if (invalid_column_names = order.select{|column_name, *| !@table.has_column?(column_name)}.keys).any?
            errors << {
              exception: ChinookSinatraApi::Persistence::ColumnNotFoundException.new(column_names: invalid_column_names),
            }
          end
          if !order.keys.one?
            errors << {
              exception: ChinookSinatraApi::Persistence::UnsupportedActionException.new("All orders must have only one key"),
            }
          end
          if order.detect{|k, v| v != "ASC" && v != "DESC"}
            errors << {
              exception: ChinookSinatraApi::Persistence::UnsupportedActionException.new("All order values must be 'ASC' or 'DESC'"),
            }
          end
        end
      end
    end

    if !@limit.is_a?(Integer)
      errors << {
        exception: ChinookSinatraApi::Persistence::UnsupportedActionException.new("Limit value must be a Integer"),
      }
    end

    if !@offset.is_a?(Integer)
      errors << {
        exception: ChinookSinatraApi::Persistence::UnsupportedActionException.new("Offset value must be a Integer"),
      }
    end

    errors.uniq
  end

end
