module Components
  module ComponentHelper
    def component(name, props = {})
      yield props if block_given?

      render(
        "#{name}_component".classify.constantize.new(props)
      )
    end
  end
end
