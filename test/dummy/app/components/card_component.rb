class CardComponent < Components::Component
  attribute :id

  has_one :header
  has_many :sections do
    attribute :size
    has_one :header
  end
  has_one :footer
end
