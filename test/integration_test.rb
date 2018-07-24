require 'test_helper'

class IntegrationTest < ActionDispatch::IntegrationTest
  test 'rendering components' do
    get '/'

    assert_select 'div.Card#card_1' do
      assert_select 'div.Card-header', 'Header'
      assert_select 'div.Card-section', 'Section 1'
      assert_select 'div.Card-section', 'Section 2'
      assert_select 'div.Card-footer', 'Footer'
    end

    assert_select 'div.Card#card_2' do
      assert_select 'div.Card-header', 'Header'
      assert_select 'div.Card-section', 'Section 1'
      assert_select 'div.Card-section', 'Section 2'
      assert_select 'div.Card-footer', 'Footer'
    end

    assert_select 'div.Card#card_3' do
      assert_select 'div.Card-header', 'Header'
      assert_select 'div.Card-section', 'Section 1'
      assert_select 'div.Card-section', 'Section 2'
      assert_select 'div.Card-footer', 'Footer'
    end
  end
end
