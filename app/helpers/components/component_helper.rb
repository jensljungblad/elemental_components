module Components
  module ComponentHelper
    def method_missing(method_name, *arguments, &block)
      if @_component
        @_component.send(method_name, *arguments, &block)
      else
        super
      end
    end

    def respond_to_missing?(method_name, include_private = false)
      @_component && @_component.respond_to?(method_name) || super
    end

    def component(name, attrs = {})
      yield attrs if block_given?

      @_component = "#{name}_component".classify.constantize.new(attrs)

      render(
        partial: "#{name}/#{name}"
      )
    ensure
      @_component = nil
    end
  end
end
