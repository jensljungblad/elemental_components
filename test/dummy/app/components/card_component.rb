class CardComponent < Components::Component
  attribute :header, Components::Types::Strict::String
  attribute :sections, Components::Types::Strict::String
  attribute :footer, Components::Types::Strict::String
end
