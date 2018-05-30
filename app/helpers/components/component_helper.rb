module Components
  module ComponentHelper
    def render_component(name, attrs = {})
      yield attrs if block_given?

      component = "#{name}_component".classify.constantize.new(attrs)

      render(
        partial: "#{name}/#{name}", object: component, as: :component
      )
    end
  end
end
