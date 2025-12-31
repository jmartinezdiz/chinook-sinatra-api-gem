# frozen_string_literal: true

######################################################
# SEARCHER
######################################################
class ChinookSinatraApi::Persistence::Searcher

  ######################################################
  # CONSTRUCTOR
  ######################################################
  def initialize(table:, conditions: {})
    @table = table
    @conditions = to_conditions(conditions)
    @errors = calculate_errors
  end

  ######################################################
  # PUBLIC INSTANCE METHODS
  ######################################################
  def search
    @table.all(conditions: @conditions)
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

  def calculate_errors
    errors = []
    unless @conditions.is_a?(Hash)
      errors << {
        exception: ChinookSinatraApi::Persistence::UnsupportedActionException.new("Conditions must be a Hash"),
      }
    end
    if @conditions.any?{|column_name, *| !column_name.is_a?(String) && !column_name.is_a?(Symbol)}
      errors << {
        exception: ChinookSinatraApi::Persistence::UnsupportedActionException.new("Conditions keys must be a String"),
      }
    end
    if (invalid_column_names = @conditions.map{|column_name, *| !@table.has_column?(column_name)}).any?
      errors << {
        exception: ChinookSinatraApi::Persistence::ColumnNotFoundException.new(column_names: invalid_column_names),
      }
    end
    errors.uniq
  end

end
