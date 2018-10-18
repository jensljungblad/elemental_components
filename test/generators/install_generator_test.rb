require 'test_helper'
require_relative '../../lib/generators/components/install_generator'

class InstallGeneratorTest < Rails::Generators::TestCase
  tests Components::InstallGenerator
  destination File.expand_path('../tmp', __dir__)
  setup :prepare_destination

  test 'component generator' do
    run_generator
    assert_file 'app/styleguide/layouts/example.html.erb'
    assert_file 'app/styleguide/pages/01_home.md'
    assert_directory 'app/styleguide/pages/02_components'
  end
end
