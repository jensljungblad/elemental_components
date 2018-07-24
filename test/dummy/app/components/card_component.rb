class CardComponent < Components::Component
  attribute :header
  attribute :sections, default: []
  attribute :footer
end
