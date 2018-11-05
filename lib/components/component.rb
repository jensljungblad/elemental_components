module Components
  class Component < Element
    def render
      @view.render 'card/card', to_h
    end
  end
end
