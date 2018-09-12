require 'test_helper'
require_relative '../lib/generators/components/component_generator'

class ComponentGeneratorTest < Rails::Generators::TestCase
  tests Components::ComponentGenerator
  destination File.expand_path('../tmp', __dir__)
  setup :prepare_destination

  test 'component generator' do
    system 'mkdir', '-p', "#{destination_root}/app/views/styleguide/components"
    run_generator %w(foobar)
    assert_file 'app/components/foobar_component.rb'
    assert_file 'app/components/foobar/_foobar.html.erb'
    assert_file 'app/components/foobar/foobar.css'
    assert_file 'app/components/foobar/foobar.js'
    assert_file 'app/views/styleguide/components/foobar.md'
  end

  test 'component generator when no style guide directory' do
    assert_raises do
      run_generator %w(foobar)
    end
  end

  test 'component generator when no components directory' do
    system 'mkdir', '-p', "#{destination_root}/app/views/styleguide"
    assert_raises do
      run_generator %w(foobar)
    end
  end
end
