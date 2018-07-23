require 'test_helper'

class ComponentsTest < ActionDispatch::IntegrationTest
  test 'components' do
    get '/'

    assert_select 'div.Panel' do
      assert_select 'div.Panel-header', 'Inlined header'
      assert_select 'div.Panel-body', 'Inlined body'
    end

    assert_select 'div.Panel' do
      assert_select 'div.Panel-header', 'Captured header'
      assert_select 'div.Panel-body', 'Captured body'
    end

    assert_select 'div.Card' do
      assert_select 'div.Card-header', 'Captured header'
      assert_select 'div.Card-section', 'Section subcomponent 1'
      assert_select 'div.Card-section', 'Section subcomponent 2'
      assert_select 'div.Card-footer', 'Captured footer'
    end
  end
end
