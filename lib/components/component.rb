module Components
  class Component
    class << self
      def props
        @_props ||= {}
      end

      def prop(prop, default: nil)
        props[prop] = { default: default }

        define_method(prop) do
          instance_variable_get("@#{prop}")
        end
      end
    end

    def initialize(props)
      self.class.props.each do |prop_name, prop_options|
        value = props.delete(prop_name) || prop_options[:default]

        unless value.present?
          raise "Prop must be passed to #{self.class.name} or assigned a default value: #{prop_name}"
        end

        instance_variable_set("@#{prop_name}", value)
      end

      unless props.keys.empty?
        raise "Unknown props passed to #{self.class.name}: #{props.keys}"
      end
    end
  end
end
