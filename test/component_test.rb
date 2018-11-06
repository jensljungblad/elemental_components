require 'test_helper'

class ComponentTest < ActiveSupport::TestCase
  test 'serialize when initialized with nothing' do
    component_class = Class.new(Components::Component)
    component = component_class.new(view_class.new)
    assert_equal ({
      content: nil
    }), component.serialize
  end

  test 'serialize when initialized with content' do
    component_class = Class.new(Components::Component)
    component = component_class.new(view_class.new) { 'foo' }
    assert_equal ({
      content: 'foo'
    }), component.serialize
  end

  test 'serialize when initialized with attributes' do
    component_class = Class.new(Components::Component) do
      attribute :foo
      attribute :bar
      attribute :baz, default: 'baz'
      attribute :qux, &:upcase
    end
    component = component_class.new(:view, bar: 'bar', qux: 'qux')
    assert_equal ({
      foo: nil,
      bar: 'bar',
      baz: 'baz',
      qux: 'QUX',
      content: nil
    }), component.serialize
  end

  test 'serialize when element not initialized' do
    component_class = Class.new(Components::Component) do
      element :foo
    end
    component = component_class.new(view_class.new)
    assert_equal ({
      foo: nil,
      content: nil
    }), component.serialize
  end

  test 'serialize when multi-element not initialized' do
    component_class = Class.new(Components::Component) do
      element :foo, multiple: true
    end
    component = component_class.new(view_class.new)
    assert_equal ({
      foos: [],
      content: nil
    }), component.serialize
  end

  test 'serialize when initialized with element with content' do
    component_class = Class.new(Components::Component) do
      element :foo
    end
    component = component_class.new(view_class.new)
    component.foo { 'foo' }
    assert_equal ({
      foo: {
        content: 'foo'
      },
      content: nil
    }), component.serialize
  end

  test 'serialize when initialized with element with attributes' do
    component_class = Class.new(Components::Component) do
      element :foo do
        attribute :foo
        attribute :bar
        attribute :baz, default: 'baz'
        attribute :qux, &:upcase
      end
    end
    component = component_class.new(:view)
    component.foo(bar: 'bar', qux: 'qux')
    assert_equal ({
      foo: {
        foo: nil,
        bar: 'bar',
        baz: 'baz',
        qux: 'QUX',
        content: nil
      },
      content: nil
    }), component.serialize
  end

  test 'serialize when initialized with multi-element' do
    component_class = Class.new(Components::Component) do
      element :foo, multiple: true
    end
    component = component_class.new(view_class.new)
    component.foo { 'foo' }
    component.foo { 'bar' }
    assert_equal ({
      foos: [
        { content: 'foo' },
        { content: 'bar' }
      ],
      content: nil
    }), component.serialize
  end

  test 'serialize when initialized with element with content and nested element with content' do
    component_class = Class.new(Components::Component) do
      element :foo do
        element :bar
      end
    end
    component = component_class.new(view_class.new)
    component.foo do |cc|
      cc.bar { 'bar' }
      'foo'
    end
    assert_equal ({
      foo: {
        bar: {
          content: 'bar'
        },
        content: 'foo'
      },
      content: nil
    }), component.serialize
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
