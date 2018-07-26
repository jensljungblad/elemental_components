require 'test_helper'

class ComponentTest < ActiveSupport::TestCase
  test 'initialize attribute with no value' do
    component_class = Class.new(Components::Component) do
      attribute :foo
    end
    component = component_class.new(:view)
    assert_nil component.instance_variable_get(:@foo)
  end

  test 'initialize attribute with value' do
    component_class = Class.new(Components::Component) do
      attribute :foo
    end
    component = component_class.new(:view, foo: 'foo')
    assert_equal 'foo', component.instance_variable_get(:@foo)
  end

  test 'initialize attribute with default value' do
    component_class = Class.new(Components::Component) do
      attribute :foo, default: 'foo'
    end
    component = component_class.new(:view)
    assert_equal 'foo', component.instance_variable_get(:@foo)
  end

  test 'get attribute' do
    component_class = Class.new(Components::Component) do
      attribute :foo
    end
    component = component_class.new(:view, foo: 'foo')
    assert_equal component.instance_variable_get(:@foo), component.foo
  end

  test 'set element' do
    component_class = Class.new(Components::Component) do
      element :foo
    end
    component = component_class.new(:view)
    component.foo 'foo'
    assert_equal 'foo', component.instance_variable_get(:@foo).value
  end

  test 'set element with block' do
    view_class = Class.new do
      def capture
        yield
      end
    end
    component_class = Class.new(Components::Component) do
      element :foo
    end
    component = component_class.new(view_class.new)
    component.foo { 'foo' }
    assert_equal 'foo', component.instance_variable_get(:@foo).value
  end

  test 'set element with attribute' do
    component_class = Class.new(Components::Component) do
      element :foo do
        attribute :bar
      end
    end
    component = component_class.new(:view)
    component.foo 'foo', bar: 'baz'
    assert_equal 'baz', component.instance_variable_get(:@foo).bar
  end

  test 'set element with attribute with default value' do
    component_class = Class.new(Components::Component) do
      element :foo do
        attribute :bar, default: 'baz'
      end
    end
    component = component_class.new(:view)
    component.foo 'foo'
    assert_equal 'baz', component.instance_variable_get(:@foo).bar
  end

  test 'set element collection' do
    component_class = Class.new(Components::Component) do
      element :foo, collection: true
    end
    component = component_class.new(:view)
    component.foo 'foo'
    component.foo 'bar'
    assert_equal 2, component.instance_variable_get(:@foo).length
    assert_equal 'foo', component.instance_variable_get(:@foo)[0].value
    assert_equal 'bar', component.instance_variable_get(:@foo)[1].value
  end

  test 'get element' do
    component_class = Class.new(Components::Component) do
      element :foo
    end
    component = component_class.new(:view)
    component.foo 'foo'
    assert_equal component.instance_variable_get(:@foo), component.foo
  end

  test 'get element when not set' do
    component_class = Class.new(Components::Component) do
      element :foo
    end
    component = component_class.new(:view)
    assert_nil component.foo.value
  end

  test 'get element collection when not set' do
    component_class = Class.new(Components::Component) do
      element :foo, collection: true
    end
    component = component_class.new(:view)
    assert_equal [], component.foo
  end
end
