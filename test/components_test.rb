require 'test_helper'

class ComponentsTest < ActiveSupport::TestCase
  test '#component_names returns an array of components' do
    assert_equal ['card', 'comment', 'objects/media_object'], Components.component_names
  end

  # rubocop:disable Style/WordArray
  test '#page_names returns a hash of page names' do
    assert_equal [
      ['01_home', 'Home'],
      ['02_pages', 'Pages', [
        ['01_page_one', 'Page One'],
        ['02_page_two', 'Page Two']
      ]],
      ['03_components', 'Components', [
        ['card', 'Card'],
        ['comment', 'Comment'],
        ['objects', 'Objects', [
          ['media_object', 'Media Object']
        ]]
      ]]
    ], Components.page_names
  end
  # rubocop:enable Style/WordArray
end
