# frozen_string_literal: true

class ChinookSinatraApi::Persistence::ElementNotFoundException < StandardError

  ######################################################
  # CONSTRUCTOR
  ######################################################
  def initialize
    super("Not found element")
  end

end
