module Components
  module Context
    def method_missing(method_name, *arguments, &block)
      if @_component.respond_to?(method_name)
        @_component.send(method_name, *arguments, &block)
      else
        super
      end
    end

    def respond_to_missing?(method_name, include_private = false)
      (@_component && @_component.respond_to?(method_name)) || super
    end
  end
end
