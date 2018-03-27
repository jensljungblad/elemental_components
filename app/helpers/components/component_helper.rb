module Components
  module ComponentHelper
    def component(name, props = {})
      yield props if block_given?

      component = "#{name}_component".classify.constantize.new(props)

      render(
        partial: "#{name}/#{name}",
        object: component
      )
    end
  end
end
