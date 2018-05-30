module Components
  module ComponentHelper
    def component(name, attrs = {})
      yield attrs if block_given?

      component = "#{name}_component".classify.constantize.new(attrs)

      view_renderer.render(
        Components::View.new(self, component), partial: "#{name}/#{name}"
      )
    end
  end
end
