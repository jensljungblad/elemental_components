require 'test_helper'

class ComponentHelperTest < ActionView::TestCase
  include Components::ComponentHelper

  test 'render component setting elements' do
    output = component 'card', id: 'id' do |c|
      c.header 'Header'
      c.sections 'Section 1', size: 'large'
      c.sections 'Section 2', size: 'small'
      c.footer 'Footer'
    end

    assert_dom_equal_squished %(
      <div id="id" class="Card">
        <div class="Card-header"> Header </div>
        <div class="Card-section Card-section--large"> Section 1 </div>
        <div class="Card-section Card-section--small"> Section 2 </div>
        <div class="Card-footer"> Footer </div>
      </div>
    ), output
  end

  test 'render component setting elements with blocks' do
    output = component 'card', id: 'id' do |c|
      c.header 'Header'
      c.sections(size: 'large') { 'Section 1' }
      c.sections(size: 'small') { 'Section 2' }
      c.footer 'Footer'
    end

    assert_dom_equal_squished %(
      <div id="id" class="Card">
        <div class="Card-header"> Header </div>
        <div class="Card-section Card-section--large"> Section 1 </div>
        <div class="Card-section Card-section--small"> Section 2 </div>
        <div class="Card-footer"> Footer </div>
      </div>
    ), output
  end

  private

  def assert_dom_equal_squished(expected, actual)
    assert_dom_equal(expected.squish, actual.squish)
  end
end
