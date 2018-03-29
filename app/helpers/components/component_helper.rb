module Components
  module ComponentHelper
    def component(name, attrs = {})
      yield attrs if block_given?

      component = "#{name}_component".classify.constantize.new(attrs)

      render(
        partial: "#{name}/#{name}",
        object: component
      )
    end
  end
end
