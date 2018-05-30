module Components
  module ComponentHelper
    def component(name, attrs = {})
      yield attrs if block_given?

      component = "#{name}_component".classify.constantize.new(attrs)

      view_class = Class.new(SimpleDelegator) do
        define_method :method_missing do |method_name, *arguments, &block|
          if component.respond_to?(method_name)
            component.send(method_name, *arguments, &block)
          else
            super(method_name, *arguments, &block)
          end
        end

        define_method :respond_to_missing? do |method_name, include_private = false|
          component.respond_to?(method_name) || super(method_name, include_private)
        end
      end

      view_renderer.render(
        view_class.new(self), partial: "#{name}/#{name}"
      )
    end
  end
end
