require 'test_helper'

class ComponentHelperTest < ActionView::TestCase
  include Components::ComponentHelper

  test 'render component initializing elements with values' do
    output = component 'card', id: 'id' do |c|
      c.header value: 'Header'
      c.sections value: 'Section 1', size: 'large'
      c.sections value: 'Section 2', size: 'small'
      c.footer value: 'Footer'
    end

    assert_dom_equal_squished %(
      <div id="id" class="card">
        <div class="card__header"> Header </div>
        <div class="card__section card__section--large"> Section 1 </div>
        <div class="card__section card__section--small"> Section 2 </div>
        <div class="card__footer"> Footer </div>
      </div>
    ), output
  end

  test 'render component initializing elements with values using blocks' do
    output = component 'card', id: 'id' do |c|
      c.header { 'Header' }
      c.sections(size: 'large') { 'Section 1' }
      c.sections(size: 'small') { 'Section 2' }
      c.footer { 'Footer' }
    end

    assert_dom_equal_squished %(
      <div id="id" class="card">
        <div class="card__header"> Header </div>
        <div class="card__section card__section--large"> Section 1 </div>
        <div class="card__section card__section--small"> Section 2 </div>
        <div class="card__footer"> Footer </div>
      </div>
    ), output
  end

  test 'render component initializing nested elements with values' do
    output = component 'card', id: 'id' do |c|
      c.header value: 'Header'
      c.sections do |cc|
        cc.header value: 'Section Header 1'
        'Section 1'
      end
      c.sections do |cc|
        cc.header value: 'Section Header 2'
        'Section 2'
      end
      c.footer value: 'Footer'
    end

    assert_dom_equal_squished %(
      <div id="id" class="card">
        <div class="card__header"> Header </div>
        <div class="card__section">
          <div class="card__section__header"> Section Header 1 </div>
          Section 1
        </div>
        <div class="card__section">
          <div class="card__section__header"> Section Header 2 </div>
          Section 2
        </div>
        <div class="card__footer"> Footer </div>
      </div>
    ), output
  end

  test 'render namespaced component' do
    output = component 'objects/media_object' do |c|
      c.media value: 'Media'
      c.body value: 'Body'
    end

    assert_dom_equal_squished %(
      <div class="media-object">
        <div class="media-object__media"> Media </div>
        <div class="media-object__body"> Body </div>
      </div>
    ), output
  end

  private

  def assert_dom_equal_squished(expected, actual)
    assert_dom_equal(expected.squish, actual.squish)
  end
end
