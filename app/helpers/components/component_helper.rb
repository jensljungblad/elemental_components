module Components
  module ComponentHelper
    def component(name, attrs = {})
      yield attrs if block_given?

      component = "#{name}_component".classify.constantize.new(attrs)
      view = controller.view_context
      view.instance_variable_set(:@_component, component)
      view.render "#{name}/#{name}"
    end
  end
end
