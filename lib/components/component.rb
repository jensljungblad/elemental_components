module Components
  class Component < Element
    # TODO: we need to calculate the proper component name here
    def render
      @view.render 'card/card', serialize
    end
  end
end
