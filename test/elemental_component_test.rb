# frozen_string_literal: true

require "test_helper"

class ElementalComponentTest < ActiveSupport::TestCase
  test "initialize with nothing" do
    component_class = Class.new(ElementalComponents::Component)
    component = component_class.new(view_class.new)
    assert_nil component.to_s
  end

  test "initialize with block" do
    component_class = Class.new(ElementalComponents::Component)
    component = component_class.new(view_class.new) { "foo" }
    assert_equal "foo", component.to_s
  end

  test "initialize by overwriting existing method with attribute" do
    e = assert_raises(ElementalComponents::Error) do
      Class.new(ElementalComponents::Component) do
        attribute :to_s
      end
    end
    assert_equal "Method 'to_s' already exists.", e.message
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

  test "initialize by overwriting existing method with element" do
    e = assert_raises(ElementalComponents::Error) do
      Class.new(ElementalComponents::Component) do
        def foo
          "foo"
        end

        element :foo
      end
    end
    assert_equal "Method 'foo' already exists.", e.message
  end

  test "initialize element with block" do
    component_class = Class.new(ElementalComponents::Component) do
      element :foo
    end
    component = component_class.new(view_class.new)
    component.foo { "foo" }
    assert_equal "foo", component.foo.to_s
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

  test "initialize element with block with nested element with block" do
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
    assert_equal "foo", component.foo.to_s
    assert_equal "bar", component.foo.bar.to_s
  end

  test "initialize element with multiple true" do
    component_class = Class.new(ElementalComponents::Component) do
      element :foo, multiple: true
    end
    component = component_class.new(view_class.new)
    component.foo { "foo" }
    component.foo { "bar" }
    assert_equal 2, component.foos.length
    assert_equal "foo", component.foos[0].to_s
    assert_equal "bar", component.foos[1].to_s
  end

  test "initialize element with multiple true when singular and plural name are the same" do
    component_class = Class.new(ElementalComponents::Component) do
      element :foos, multiple: true
    end
    component = component_class.new(view_class.new)
    component.foos { "foo" }
    component.foos { "bar" }
    assert_equal 2, component.foos.length
    assert_equal "foo", component.foos[0].to_s
    assert_equal "bar", component.foos[1].to_s
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

  test "initialize with given attribute and successfull validation" do
    component_class = Class.new(ElementalComponents::Component) do
      attribute :foo
      validates :foo, presence: true
    end
    assert_nothing_raised { component_class.new(view_class.new, foo: "bar") }
  end

  test "initialize without attribute and failing validation" do
    component_class = Class.new(ElementalComponents::Component) do
      attribute :foo
      validates :foo, presence: true
    end
    e = assert_raises(ActiveModel::ValidationError) { component_class.new(view_class.new) }
    assert_equal "Validation failed: Foo can't be blank", e.message
  end

  test "initialize with default value and successfull validation" do
    component_class = Class.new(ElementalComponents::Component) do
      attribute :foo, default: "bar"
      validates :foo, presence: true
    end
    assert_nothing_raised { component_class.new(view_class.new) }
  end

  test "initialize element and successfull element validation" do
    component_class = Class.new(ElementalComponents::Component) do
      element :foo
      validates :foo, presence: true
    end
    assert_nothing_raised do
      component_class.new(view_class.new, {}) do |c|
        c.foo { "lalala" }
      end
    end
  end

  test "initialize element and failing element validation" do
    component_class = Class.new(ElementalComponents::Component) do
      element :foo
      validates :foo, presence: true
    end
    e = assert_raises(ActiveModel::ValidationError) do
      component_class.new(view_class.new, {})
    end
    assert_equal "Validation failed: Foo can't be blank", e.message
  end

  test "initialize element and successfull element attribute validation" do
    component_class = Class.new(ElementalComponents::Component) do
      element :foo do
        attribute :bar
        validates :bar, presence: true
      end
    end
    assert_nothing_raised do
      component_class.new(view_class.new, {}) do |c|
        c.foo(bar: "lalal") { "something" }
      end
    end
  end

  test "initialize element and failing element attribute validation" do
    component_class = Class.new(ElementalComponents::Component) do
      element :foo do
        attribute :bar
        validates :bar, presence: true
      end
    end
    e = assert_raises(ActiveModel::ValidationError) do
      component_class.new(view_class.new, {}) do |c|
        c.foo { "something" }
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
