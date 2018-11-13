require "test_helper"
require_relative "../../lib/generators/components/component_generator"

class ComponentGeneratorTest < Rails::Generators::TestCase
  tests Components::ComponentGenerator
  destination File.expand_path("../tmp", __dir__)
  setup :prepare_destination

  test "component generator" do
    run_generator %w[foobar]
    assert_file "app/components/foobar_component.rb"
    assert_file "app/components/foobar/_foobar.html.erb"
    assert_file "app/components/foobar/foobar.css"
    assert_file "app/components/foobar/foobar.js"
  end
end
