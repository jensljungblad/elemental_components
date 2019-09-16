# frozen_string_literal: true

require "test_helper"

class ComponentsTest < ActiveSupport::TestCase
  test "Components::Error class is defined" do
    assert defined?(Components::Error)
  end

  test ".components_path returns the components root path" do
    assert_equal Rails.root.join("app", "components"), Components.components_path
  end

  test ".component_names returns an array of components" do
    assert_equal ["card", "comment", "objects/media_object"], Components.component_names
  end
end
