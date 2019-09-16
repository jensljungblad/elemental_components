# frozen_string_literal: true

class CommentComponent < Components::Component
  attribute :comment

  delegate :user,
           :body, to: :comment
end
