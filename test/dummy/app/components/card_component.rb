class CardComponent < Components::Component
  attribute :id
  attribute :class
  element :header
  element :section, multiple: true do
    attribute :size
    element :header
  end
  element :footer
end
