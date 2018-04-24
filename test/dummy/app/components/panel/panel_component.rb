class PanelComponent < Components::Component
  BLOCK_ATTRIBUTE = :body

  attribute :header, Components::Types::String
  attribute :body, Components::Types::String
end
