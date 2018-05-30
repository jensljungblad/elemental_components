module Components
  class View < SimpleDelegator
    def initialize(view, component)
      super(view)

      @_component = component

      component.public_methods(false).each do |method|
        self.class.delegate method, to: :@_component
      end
    end
  end
end
