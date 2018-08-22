module Styleguide
  class ExampleComponent < Components::Component
    has_one :body

    def iframe_id
      @iframe_id ||= SecureRandom.uuid
    end
  end
end
