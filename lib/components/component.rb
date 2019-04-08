module Components
  class Component < Element
    def self.model_name
      ActiveModel::Name.new(Components::Component)
    end

    def self.component_name
      class_name.chomp("Component").demodulize.underscore
    end

    def self.component_path
      class_name.chomp("Component").underscore
    end

    # Allow Components to lookup their original classname
    # even if created with Class.new(SomeComponent)
    def self.class_name
      name || superclass.name
    end

    def render
      render_partial to_partial_path
    end

    def _name
      super || self.class.component_name
    end

    def to_partial_path
      [self.class.component_path, self.class.component_name].join("/")
    end
  end
end
