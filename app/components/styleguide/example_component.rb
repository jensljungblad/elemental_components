module Styleguide
  class ExampleComponent < Components::Component
    has_one :example
    has_one :example_source

    def iframe_id
      @iframe_id ||= SecureRandom.uuid
    end
  end
end
