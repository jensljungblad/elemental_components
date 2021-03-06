# frozen_string_literal: true

require "test_helper"

class ElementalComponentsTest < ActiveSupport::TestCase
  test "Components::Error class is defined" do
    assert defined?(ElementalComponents::Error)
  end

  test ".components_path returns the components root path" do
    assert_equal Rails.root.join("app", "components"), ElementalComponents.components_path
  end

  test ".component_names returns an array of components" do
    assert_equal ["card", "comment", "objects/media_object"], ElementalComponents.component_names
  end
end
