module Components
  module ComponentHelper
    def component(name, attrs = {})
      component_class = "#{name}_component".classify.constantize

      if block_given?
        attrs.reverse_merge!(
          component_class::BLOCK_ATTRIBUTE => capture { yield }
        )
      end

      render(
        partial: "#{name}/#{name}",
        object: component_class.new(attrs)
      )
    end
  end
end
