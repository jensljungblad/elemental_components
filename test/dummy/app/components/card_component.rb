class CardComponent < Components::Component
  attribute :id

  element :header
  element :sections, collection: true do
    attribute :size
  end
  element :footer
end
