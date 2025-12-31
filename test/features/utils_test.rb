# frozen_string_literal: true

require "test_helper"

class ChinookSinatraApiUtilsTest < BaseTest

  def test_underscore
    assert_equal ChinookSinatraApi::Utils::String.underscore(""), ""
    assert_equal ChinookSinatraApi::Utils::String.underscore("media_type"), "media_type"
    assert_equal ChinookSinatraApi::Utils::String.underscore("MediaType"), "media_type"
  end

  def test_upper_camelize
    assert_equal ChinookSinatraApi::Utils::String.upper_camelize(""), ""
    assert_equal ChinookSinatraApi::Utils::String.upper_camelize("media_type"), "MediaType"
    assert_equal ChinookSinatraApi::Utils::String.upper_camelize("MediaType"), "MediaType"
  end

end
