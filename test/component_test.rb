require 'test_helper'

class ComponentTest < ActiveSupport::TestCase
  test 'initialize with no value' do
    component_class = Class.new(Components::Component) do
      attribute :foo
    end
    component = component_class.new(:view)
    assert_nil component.instance_variable_get(:@foo)
  end

  test 'initialize with value' do
    component_class = Class.new(Components::Component) do
      attribute :foo
    end
    component = component_class.new(:view, foo: 'foo')
    assert_equal 'foo', component.instance_variable_get(:@foo).value
  end

  test 'initialize with array value' do
    component_class = Class.new(Components::Component) do
      attribute :foo
    end
    component = component_class.new(:view, foo: %w(foo bar))
    assert_equal 2, component.instance_variable_get(:@foo).length
    assert_equal 'foo', component.instance_variable_get(:@foo)[0].value
    assert_equal 'bar', component.instance_variable_get(:@foo)[1].value
  end

  test 'initialize with default value' do
    component_class = Class.new(Components::Component) do
      attribute :foo, default: 'foo'
    end
    component = component_class.new(:view)
    assert_equal 'foo', component.instance_variable_get(:@foo).value
  end

  test 'get attribute' do
    component_class = Class.new(Components::Component) do
      attribute :foo
    end
    component = component_class.new(:view, foo: 'foo')
    assert_equal component.instance_variable_get(:@foo), component.foo
  end

  test 'set attribute when not initialized' do
    component_class = Class.new(Components::Component) do
      attribute :foo
    end
    component = component_class.new(:view)
    component.foo 'foo'
    assert_equal 'foo', component.instance_variable_get(:@foo).value
  end

  test 'set attribute when initialized' do
    component_class = Class.new(Components::Component) do
      attribute :foo
    end
    component = component_class.new(:view, foo: 'foo')
    component.foo 'bar'
    assert_equal 'bar', component.instance_variable_get(:@foo).value
  end

  test 'set attribute to array value when initialized as non-array' do
    component_class = Class.new(Components::Component) do
      attribute :foo
    end
    component = component_class.new(:view, foo: 'foo')
    component.foo ['bar']
    assert_equal ['bar'], component.instance_variable_get(:@foo).value
  end

  test 'set attribute when initialized as array' do
    component_class = Class.new(Components::Component) do
      attribute :foo
    end
    component = component_class.new(:view, foo: %w(foo))
    component.foo 'bar'
    assert_equal 2, component.instance_variable_get(:@foo).length
    assert_equal 'bar', component.instance_variable_get(:@foo)[1].value
  end

  test 'set attribute to array value when initialized as array' do
    component_class = Class.new(Components::Component) do
      attribute :foo
    end
    component = component_class.new(:view, foo: %w(foo))
    component.foo ['bar']
    assert_equal 2, component.instance_variable_get(:@foo).length
    assert_equal ['bar'], component.instance_variable_get(:@foo)[1].value
  end

  test 'set attribute with attributes' do
    component_class = Class.new(Components::Component) do
      attribute :foo
    end
    component = component_class.new(:view)
    component.foo 'foo', foo: 'foo', bar: 'bar'
    assert_equal(
      { foo: 'foo', bar: 'bar' }, component.instance_variable_get(:@foo).attributes
    )
  end

  test 'set attribute with attributes when initialized as array' do
    component_class = Class.new(Components::Component) do
      attribute :foo
    end
    component = component_class.new(:view, foo: %w(foo))
    component.foo 'foo', foo: 'foo', bar: 'bar'
    assert_equal(
      { foo: 'foo', bar: 'bar' }, component.instance_variable_get(:@foo)[1].attributes
    )
  end
end
