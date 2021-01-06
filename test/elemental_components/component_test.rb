# frozen_string_literal: true

require "test_helper"

class ElementalComponents::ComponentTest < ActiveSupport::TestCase
  test "initialize with no content" do
    component_class = Class.new(ElementalComponents::Component)
    component = component_class.new(view_class.new)
    assert_nil component.content
  end

  test "initialize with content" do
    component_class = Class.new(ElementalComponents::Component)
    component = component_class.new(view_class.new) { "foo" }
    assert_equal "foo", component.content
  end

  test "initialize attribute with no value" do
    component_class = Class.new(ElementalComponents::Component) do
      attribute :foo
    end
    component = component_class.new(view_class.new)
    assert_nil component.foo
  end

  test "initialize attribute with value" do
    component_class = Class.new(ElementalComponents::Component) do
      attribute :foo
    end
    component = component_class.new(view_class.new, foo: "foo")
    assert_equal "foo", component.foo
  end

  test "initialize attribute with default value" do
    component_class = Class.new(ElementalComponents::Component) do
      attribute :foo, default: "foo"
    end
    component = component_class.new(view_class.new)
    assert_equal "foo", component.foo
  end

  test "attribute with default value is not used when false is provided" do
    component_class = Class.new(ElementalComponents::Component) do
      attribute :foo, default: "foo"
    end
    component = component_class.new(view_class.new, foo: false)
    assert_equal false, component.foo
  end

  test "initialize attribute named same as existing method" do
    e = assert_raises(ElementalComponents::Error) do
      Class.new(ElementalComponents::Component) do
        attribute :content
      end
    end
    assert_equal "Method 'content' already exists.", e.message
  end

  test "initialize element with content" do
    component_class = Class.new(ElementalComponents::Component) do
      element :foo
    end
    component = component_class.new(view_class.new)
    component.foo { "foo" }
    assert_equal "foo", component.foo.content
  end

  test "initialize element with attribute with value" do
    component_class = Class.new(ElementalComponents::Component) do
      element :foo do
        attribute :bar
      end
    end
    component = component_class.new(view_class.new)
    component.foo bar: "baz"
    assert_equal "baz", component.foo.bar
  end

  test "initialize element with content with nested element with content" do
    component_class = Class.new(ElementalComponents::Component) do
      element :foo do
        element :bar
      end
    end
    component = component_class.new(view_class.new)
    component.foo do |cc|
      cc.bar do
        "bar"
      end
      "foo"
    end
    assert_equal "foo", component.foo.content
    assert_equal "bar", component.foo.bar.content
  end

  test "initialize element with multiple true" do
    component_class = Class.new(ElementalComponents::Component) do
      element :foo, multiple: true
    end
    component = component_class.new(view_class.new)
    component.foo { "foo" }
    component.foo { "bar" }
    assert_equal 2, component.foos.length
    assert_equal "foo", component.foos[0].content
    assert_equal "bar", component.foos[1].content
  end

  test "initialize element with multiple true when singular and plural name are the same" do
    component_class = Class.new(ElementalComponents::Component) do
      element :foos, multiple: true
    end
    component = component_class.new(view_class.new)
    component.foos { "foo" }
    component.foos { "bar" }
    assert_equal 2, component.foos.length
    assert_equal "foo", component.foos[0].content
    assert_equal "bar", component.foos[1].content
  end

  test "initialize element named same as exsiting method" do
    e = assert_raises(ElementalComponents::Error) do
      Class.new(ElementalComponents::Component) do
        element :content
      end
    end
    assert_equal "Method 'content' already exists.", e.message
  end

  test "get element when not set" do
    component_class = Class.new(ElementalComponents::Component) do
      element :foo
    end
    component = component_class.new(view_class.new)
    assert_nil component.foo
  end

  test "get element with multiple true when not set" do
    component_class = Class.new(ElementalComponents::Component) do
      element :foo, multiple: true
    end
    component = component_class.new(view_class.new)
    assert_equal [], component.foos
  end

  test "initialize with successful content validation" do
    component_class = Class.new(ElementalComponents::Component) do
      validates :content, presence: true
    end
    assert_nothing_raised do
      component_class.new(view_class.new) { "foo" }
    end
  end

  test "initialize with failing content validation" do
    component_class = Class.new(ElementalComponents::Component) do
      validates :content, presence: true
    end
    e = assert_raises(ActiveModel::ValidationError) do
      component_class.new(view_class.new)
    end
    assert_equal "Validation failed: Content can't be blank", e.message
  end

  test "initialize with successful attribute validation" do
    component_class = Class.new(ElementalComponents::Component) do
      attribute :foo
      validates :foo, presence: true
    end
    assert_nothing_raised do
      component_class.new(view_class.new, foo: "bar")
    end
  end

  test "initialize with failing attribute validation" do
    component_class = Class.new(ElementalComponents::Component) do
      attribute :foo
      validates :foo, presence: true
    end
    e = assert_raises(ActiveModel::ValidationError) do
      component_class.new(view_class.new)
    end
    assert_equal "Validation failed: Foo can't be blank", e.message
  end

  test "initialize with successful attribute validation when attribute has default value" do
    component_class = Class.new(ElementalComponents::Component) do
      attribute :foo, default: "bar"
      validates :foo, presence: true
    end
    assert_nothing_raised do
      component_class.new(view_class.new)
    end
  end

  test "initialize with successful element validation" do
    component_class = Class.new(ElementalComponents::Component) do
      element :foo
      validates :foo, presence: true
    end
    assert_nothing_raised do
      component_class.new(view_class.new, {}) do |c|
        c.foo { "bar" }
      end
    end
  end

  test "initialize with failing element validation" do
    component_class = Class.new(ElementalComponents::Component) do
      element :foo
      validates :foo, presence: true
    end
    e = assert_raises(ActiveModel::ValidationError) do
      component_class.new(view_class.new, {})
    end
    assert_equal "Validation failed: Foo can't be blank", e.message
  end

  test "initialize with successful attribute validation on element" do
    component_class = Class.new(ElementalComponents::Component) do
      element :foo do
        attribute :bar
        validates :bar, presence: true
      end
    end
    assert_nothing_raised do
      component_class.new(view_class.new, {}) do |c|
        c.foo(bar: "baz") { "baz" }
      end
    end
  end

  test "initialize with failing attribute validation on element" do
    component_class = Class.new(ElementalComponents::Component) do
      element :foo do
        attribute :bar
        validates :bar, presence: true
      end
    end
    e = assert_raises(ActiveModel::ValidationError) do
      component_class.new(view_class.new, {}) do |c|
        c.foo { "bar" }
      end
    end
    assert_equal "Validation failed: Bar can't be blank", e.message
  end

  private

  def view_class
    Class.new do
      def capture(element)
        yield(element)
      end
    end
  end
end
