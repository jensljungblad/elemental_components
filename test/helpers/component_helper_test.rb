# frozen_string_literal: true

require "test_helper"

class ComponentHelperTest < ActionView::TestCase
  include Components::ComponentHelper

  test "render component with elements" do
    output = component "card", id: "id" do |c|
      c.header { "Header" }
      c.section(size: "large") { "Section 1" }
      c.section(size: "small") { "Section 2" }
      c.footer { "Footer" }
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

  test "render component with nested elements" do
    output = component "card", id: "id" do |c|
      c.header { "Header" }
      c.section do |cc|
        cc.header { "Section Header 1" }
        "Section 1"
      end
      c.section do |cc|
        cc.header { "Section Header 2" }
        "Section 2"
      end
      c.footer { "Footer" }
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

  test "render component with model" do
    output = component "comment", comment: Comment.new(
      id: 1,
      user: User.new(
        id: 1,
        name: "Name"
      ),
      body: "Body"
    )

    assert_dom_equal_squished %(
      <div class="media-object">
        <div class="media-object__media">
          <a href="/users/1">Name</a>
        </div>
        <div class="media-object__body"> Body </div>
      </div>
    ), output
  end

  test "render namespaced component" do
    output = component "objects/media_object" do |c|
      c.media { "Media" }
      c.body { "Body" }
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
