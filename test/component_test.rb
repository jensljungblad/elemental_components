require 'test_helper'

class ComponentTest < ActiveSupport::TestCase
  test 'initialize with content' do
    component_class = Class.new(Components::Component)
    component = component_class.new(view_class.new) { 'foo' }
    assert_equal 'foo', component.instance_variable_get(:@yield)
  end

  test 'get yield' do
    component_class = Class.new(Components::Component)
    component = component_class.new(view_class.new) { 'foo' }
    assert_equal component.instance_variable_get(:@yield), component.to_s
  end

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

  test 'initialize element with content' do
    component_class = Class.new(Components::Component) do
      has_one :foo
    end
    component = component_class.new(view_class.new)
    component.foo { 'foo' }
    assert_equal 'foo', component.instance_variable_get(:@foo).to_s
  end

  test 'initialize element with attribute with value' do
    component_class = Class.new(Components::Component) do
      has_one :foo do
        attribute :bar
      end
    end
    component = component_class.new(:view)
    component.foo bar: 'baz'
    assert_equal 'baz', component.instance_variable_get(:@foo).bar
  end

  test 'initialize element with nested element with value using block' do
    component_class = Class.new(Components::Component) do
      has_one :foo do
        has_one :bar
      end
    end
    component = component_class.new(view_class.new)
    component.foo do |cc|
      cc.bar { 'bar' }
      'foo'
    end
    assert_equal 'foo', component.instance_variable_get(:@foo).to_s
    assert_equal 'bar', component.instance_variable_get(:@foo).bar.to_s
  end

  test 'initialize collection elements' do
    component_class = Class.new(Components::Component) do
      has_many :foo
    end
    component = component_class.new(view_class.new)
    component.foo { 'foo' }
    component.foo { 'bar' }
    assert_equal 2, component.instance_variable_get(:@foo).length
    assert_equal 'foo', component.instance_variable_get(:@foo)[0].to_s
    assert_equal 'bar', component.instance_variable_get(:@foo)[1].to_s
  end

  test 'get element' do
    component_class = Class.new(Components::Component) do
      has_one :foo
    end
    component = component_class.new(view_class.new)
    component.foo { 'foo' }
    assert_equal component.instance_variable_get(:@foo), component.foo
  end

  test 'get element when not set' do
    component_class = Class.new(Components::Component) do
      has_one :foo
    end
    component = component_class.new(:view)
    assert_nil component.foo
  end

  test 'get element collection when not set' do
    component_class = Class.new(Components::Component) do
      has_many :foo
    end
    component = component_class.new(:view)
    assert_equal [], component.foo
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
