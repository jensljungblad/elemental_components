require "test_helper"

class ComponentsTest < ActiveSupport::TestCase
  test "#component_names returns an array of components" do
    assert_equal ["card", "comment", "objects/media_object"], Components.component_names
  end
end
