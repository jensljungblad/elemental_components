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

  test "initialize by overwriting existing method with attribute" do
    e = assert_raises(Components::Error) do
      Class.new(Components::Component) do
        attribute :to_s
      end
    end
    assert_equal "Method 'to_s' already exists.", e.message
  end

  test "initialize attribute with no value" do
    component_class = Class.new(Components::Component) do
      attribute :foo
    end
    component = component_class.new(view_class.new)
    assert_nil component.foo
  end

  test "initialize attribute with value" do
    component_class = Class.new(Components::Component) do
      attribute :foo
    end
    component = component_class.new(view_class.new, foo: "foo")
    assert_equal "foo", component.foo
  end

  test "initialize attribute with default value" do
    component_class = Class.new(Components::Component) do
      attribute :foo, default: "foo"
    end
    component = component_class.new(view_class.new)
    assert_equal "foo", component.foo
  end

  test "initialize by overwriting existing method with element" do
    e = assert_raises(Components::Error) do
      Class.new(Components::Component) do
        def foo
          "foo"
        end

        element :foo
      end
    end
    assert_equal "Method 'foo' already exists.", e.message
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
    component = component_class.new(view_class.new)
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
    component = component_class.new(view_class.new)
    assert_nil component.foo
  end

  test "get element with multiple true when not set" do
    component_class = Class.new(Components::Component) do
      element :foo, multiple: true
    end
    component = component_class.new(view_class.new)
    assert_equal [], component.foos
  end

  test "initialize with given attribute and successfull validation" do
    component_class = Class.new(Components::Component) do
      attribute :foo
      validates :foo, presence: true
    end
    assert_nothing_raised { component_class.new(view_class.new, foo: "bar") }
  end

  test "initialize without attribute and failing validation" do
    component_class = Class.new(Components::Component) do
      attribute :foo
      validates :foo, presence: true
    end
    e = assert_raises(ActiveModel::ValidationError) { component_class.new(view_class.new) }
    assert_equal "Validation failed: Foo can't be blank", e.message
  end

  test "initialize with default value and successfull validation" do
    component_class = Class.new(Components::Component) do
      attribute :foo, default: "bar"
      validates :foo, presence: true
    end
    assert_nothing_raised { component_class.new(view_class.new) }
  end

  test "initialize element and successfull element validation" do
    component_class = Class.new(Components::Component) do
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
    component_class = Class.new(Components::Component) do
      element :foo
      validates :foo, presence: true
    end
    e = assert_raises(ActiveModel::ValidationError) do
      component_class.new(view_class.new, {})
    end
    assert_equal "Validation failed: Foo can't be blank", e.message
  end

  test "initialize element and successfull element attribute validation" do
    component_class = Class.new(Components::Component) do
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
    component_class = Class.new(Components::Component) do
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

  # Makes it easy for elements to do basic templating
  test "element supports render method" do
    component_class = Class.new(Components::Component) do
      element :foo do
        attribute :tag, default: :span

        def render
          "<#{tag}>#{block_content}</#{tag}>"
        end
      end
    end

    component = component_class.new(view_class.new)
    component.foo(tag: :div) { "bar" }

    assert_equal "<div>bar</div>", component.foo.to_s
  end

  # Reduce the overhead of creating very similar components
  test "extending a component extends its elements and attributes" do
    base_component_class = Class.new(Components::Component) do
      attribute :foo

      element :bar do
        element :baz
      end
    end

    # Extend the base class
    component_class = Class.new(base_component_class)

    component = component_class.new(view_class.new, foo: "foo")

    component.bar { "bar" }
    component.bar.baz { "baz" }
    assert_equal "foo", component.foo.to_s
    assert_equal "bar", component.bar.to_s
    assert_equal "baz", component.bar.baz.to_s
  end

  # Allows Components to be integrated into other components as elements.
  test "element can extend a component" do
    base_component_class = Class.new(Components::Component) do
      attribute :tag, default: :h1

      def render
        "<#{tag}>#{block_content}</#{tag}>"
      end
    end

    component_class = Class.new(Components::Component) do
      element :header, extends: base_component_class
    end

    component = component_class.new(view_class.new)

    component.header(tag: :h2) { "test" }
    assert_equal "<h2>test</h2>", component.header.to_s
  end

  # This reduces duplicate code when components share very similar elements
  test "extending a component extends elements of that component with matching names" do
    base_component_class = Class.new(Components::Component) do
      element :foo do
        attribute :tag, default: :span

        def render
          "<#{tag}>#{block_content}</#{tag}>"
        end
      end
    end

    component_class = Class.new(base_component_class) do
      element :foo do
        attribute :bar, default: :baz
      end
    end

    component = component_class.new(view_class.new)
    component.foo { "test" }
    assert_equal "<span>test</span>", component.foo.to_s
    assert_equal "baz", component.foo.bar.to_s
  end

  # This way an element can interact with another element through its parent component
  # allowing for more complex list creation
  test "elements should be able to interact with their parent component" do
    component_class = Class.new(Components::Component) do
      element :item, multiple: true

      element :group do
        element :item, multiple: true

        def render
          parent.items << "(#{items.join(', ')})"
        end
      end
    end

    component = component_class.new(view_class.new)
    component.item { "hi" }
    component.item { "hello" }
    component.group do |group|
      group.item { "yo" }
      group.item { "howdy" }
    end

    assert_equal "hi, hello, (yo, howdy)", component.items.join(", ")
  end

  test "elements can to manage classnames" do
    component_class = Class.new(Components::Component) do
      attribute :baz
      add_class :foo, :bar

      def classnames
        add_class 'baz' if baz
        super
      end
    end
    component = component_class.new(view_class.new)
    assert_equal "foo bar", component.classnames

    component_2 = component_class.new(view_class.new, baz: true)
    assert_equal "foo bar baz", component_2.classnames
  end

  private

  def view_class
    Class.new do
      def capture(element)
        yield(element)
      end

      # Avoid breakage if render is called on components
      def render(*args) end
    end
  end
end
