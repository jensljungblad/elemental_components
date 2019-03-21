require "test_helper"

class ComponentTest < ActiveSupport::TestCase
  test "initialize with nothing" do
    component_class = Class.new(Components::Component)
    component = component_class.new(view_class.new)
    assert_nil component.to_s
  end

  test "initialize with block" do
    component_class = Class.new(Components::Component)
    component = component_class.new(view_class.new) { "foo" }
    assert_equal "foo", component.to_s
  end

  test "initialize by overwriting existing attribute" do
    e = assert_raises(Components::Error) do
      Class.new(Components::Component) do
        attribute :to_s
      end
    end
    assert_equal "Attribute 'to_s' already exists.", e.message
  end

  test "initialize attribute with no value" do
    component_class = Class.new(Components::Component) do
      attribute :foo
    end
    component = component_class.new(:view)
    assert_nil component.foo
  end

  test "initialize attribute with value" do
    component_class = Class.new(Components::Component) do
      attribute :foo
    end
    component = component_class.new(:view, foo: "foo")
    assert_equal "foo", component.foo
  end

  test "initialize attribute with default value" do
    component_class = Class.new(Components::Component) do
      attribute :foo, default: "foo"
    end
    component = component_class.new(:view)
    assert_equal "foo", component.foo
  end

  test "initialize element with block" do
    component_class = Class.new(Components::Component) do
      element :foo
    end
    component = component_class.new(view_class.new)
    component.foo { "foo" }
    assert_equal "foo", component.foo.to_s
  end

  test "initialize element with attribute with value" do
    component_class = Class.new(Components::Component) do
      element :foo do
        attribute :bar
      end
    end
    component = component_class.new(:view)
    component.foo bar: "baz"
    assert_equal "baz", component.foo.bar
  end

  test "initialize element with block with nested element with block" do
    component_class = Class.new(Components::Component) do
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
    component_class = Class.new(Components::Component) do
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
    component_class = Class.new(Components::Component) do
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
    component_class = Class.new(Components::Component) do
      element :foo
    end
    component = component_class.new(:view)
    assert_nil component.foo
  end

  test "get element with multiple true when not set" do
    component_class = Class.new(Components::Component) do
      element :foo, multiple: true
    end
    component = component_class.new(:view)
    assert_equal [], component.foos
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
