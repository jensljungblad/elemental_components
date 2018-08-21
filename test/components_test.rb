require 'test_helper'

class ComponentsTest < ActiveSupport::TestCase
  test '#component_names returns an array of components' do
    assert_equal ['card', 'objects/media_object'], Components.component_names
  end

  # rubocop:disable Style/WordArray
  test '#page_names returns a hash of page names' do
    assert_equal [
      ['01_getting_started', 'Getting Started'],
      ['02_guidelines', 'Guidelines', [
        ['01_design_principles', 'Design Principles'],
        ['02_code_conventions', 'Code Conventions']
      ]],
      ['03_styles', 'Styles', [
        ['01_color', 'Color'],
        ['02_typography', 'Typography']
      ]],
      ['04_components', 'Components', [
        ['card', 'Card']
      ]]
    ], Components.page_names
  end
  # rubocop:enable Style/WordArray
end
