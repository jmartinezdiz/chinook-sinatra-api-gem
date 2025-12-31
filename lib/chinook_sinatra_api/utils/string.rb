# frozen_string_literal: true

module ChinookSinatraApi::Utils
  module String

    ######################################################
    # MODULE METHODS
    ######################################################
    def self.underscore(string)
      return string.to_s.dup unless /[A-Z-]|::/.match?(string)
      new_string = string.to_s.gsub("::", "/")
      new_string.gsub!(/(?<=[A-Z])(?=[A-Z][a-z])|(?<=[a-z\d])(?=[A-Z])/, "_")
      new_string.tr!("-", "_")
      new_string.downcase!
      new_string
    end

    def self.upper_camelize(term)
      string = term.to_s
      string = string.sub(/^[a-z\d]*/) { |match| match.capitalize! || match }
      string.gsub!(/(?:_|(\/))([a-z\d]*)/i) do
        word = $2
        substituted = word.capitalize! || word
        $1 ? "::#{substituted}" : substituted
      end
      string
    end

  end
end
