module Objects
  class MediaObjectComponent < Components::Component
    has_one :media
    has_one :body
  end
end
