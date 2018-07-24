class CardComponent < Components::Component
  attribute :id
  attribute :header
  attribute :sections, default: []
  attribute :footer
end
