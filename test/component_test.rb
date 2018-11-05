require 'test_helper'

class ComponentTest < ActiveSupport::TestCase
  test 'to_h when initialized with nothing' do
    component_class = Class.new(Components::Component)
    component = component_class.new(view_class.new)
    assert_equal ({
      content: nil
    }), component.to_h
  end

  test 'to_h when initialized with content' do
    component_class = Class.new(Components::Component)
    component = component_class.new(view_class.new) { 'foo' }
    assert_equal ({
      content: 'foo'
    }), component.to_h
  end

  test 'to_h when initialized with attributes' do
    component_class = Class.new(Components::Component) do
      attribute :foo
      attribute :bar
      attribute :baz, default: 'baz'
    end
    component = component_class.new(:view, bar: 'bar')
    assert_equal ({
      foo: nil,
      bar: 'bar',
      baz: 'baz',
      content: nil
    }), component.to_h
  end

  test 'to_h when initialized with attribute with override' do
    component_class = Class.new(Components::Component) do
      attribute :foo, &:upcase
    end
    component = component_class.new(:view, foo: 'foo')
    assert_equal ({
      foo: 'FOO',
      content: nil
    }), component.to_h
  end

  test 'to_h when element not initialized' do
    component_class = Class.new(Components::Component) do
      element :foo
    end
    component = component_class.new(view_class.new)
    assert_equal ({
      foo: nil,
      content: nil
    }), component.to_h
  end

  test 'to_h when multi-element not initialized' do
    component_class = Class.new(Components::Component) do
      element :foo, multiple: true
    end
    component = component_class.new(view_class.new)
    assert_equal ({
      foo: [],
      content: nil
    }), component.to_h
  end

  test 'to_h when initialized with element with content' do
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
    }), component.to_h
  end

  test 'to_h when initialized with element with attributes' do
    component_class = Class.new(Components::Component) do
      element :foo do
        attribute :foo
        attribute :bar
        attribute :baz, default: 'baz'
      end
    end
    component = component_class.new(:view)
    component.foo bar: 'bar'
    assert_equal ({
      foo: {
        foo: nil,
        bar: 'bar',
        baz: 'baz',
        content: nil
      },
      content: nil
    }), component.to_h
  end

  test 'to_h when initialized with multi-element' do
    component_class = Class.new(Components::Component) do
      element :foo, multiple: true
    end
    component = component_class.new(view_class.new)
    component.foo { 'foo' }
    component.foo { 'bar' }
    assert_equal ({
      foo: [
        { content: 'foo' },
        { content: 'bar' }
      ],
      content: nil
    }), component.to_h
  end

  test 'to_h when initialized with element with content and nested element with content' do
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
    }), component.to_h
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
