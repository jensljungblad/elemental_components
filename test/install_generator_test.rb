require 'test_helper'
require_relative '../lib/generators/components/install_generator'

class InstallGeneratorTest < Rails::Generators::TestCase
  tests Components::InstallGenerator
  destination File.expand_path('../tmp', __dir__)
  setup :prepare_destination

  test 'component generator' do
    run_generator
    assert_directory 'app/views/styleguide/01_components'
  end
end
