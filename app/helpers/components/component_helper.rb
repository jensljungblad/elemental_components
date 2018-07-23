module Components
  module ComponentHelper
    def component(name, attrs = {})
      yield attrs if block_given?

      component = "#{name}_component".classify.constantize.new(attrs)

      view = controller.view_context
      view.instance_variable_set(:@_component, component)

      component.public_methods(false).each do |method|
        view.singleton_class.delegate method, to: :@_component
      end

      view.render "#{name}/#{name.split('/')[-1]}"
    end
  end
end
