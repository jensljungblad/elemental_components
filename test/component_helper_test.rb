require 'test_helper'

class ComponentHelperTest < ActionView::TestCase
  include Components::ComponentHelper

  test 'renders with initialized attributes' do
    output = component 'card', header: 'Header', sections: ['Section 1', 'Section 2'], footer: 'Footer'

    assert_dom_equal_squished %(
      <div class="Card">
        <div class="Card-header"> Header </div>
        <div class="Card-section"> Section 1 </div>
        <div class="Card-section"> Section 2 </div>
        <div class="Card-footer"> Footer </div>
      </div>
    ), output
  end

  test 'renders with set attributes' do
    output = component 'card' do |c|
      c.header 'Header'
      c.sections 'Section 1', size: 'large'
      c.sections 'Section 2', size: 'small'
      c.footer 'Footer'
    end

    assert_dom_equal_squished %(
      <div class="Card">
        <div class="Card-header"> Header </div>
        <div class="Card-section Card-section--large"> Section 1 </div>
        <div class="Card-section Card-section--small"> Section 2 </div>
        <div class="Card-footer"> Footer </div>
      </div>
    ), output
  end

  test 'renders with set attributes from blocks' do
    output = component 'card' do |c|
      c.header 'Header'
      c.sections(size: 'large') { 'Section 1' }
      c.sections(size: 'small') { 'Section 2' }
      c.footer 'Footer'
    end

    assert_dom_equal_squished %(
      <div class="Card">
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
