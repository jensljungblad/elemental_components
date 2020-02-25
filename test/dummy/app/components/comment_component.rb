# frozen_string_literal: true

class CommentComponent < ElementalComponents::Component
  attribute :comment

  delegate :user,
           :body, to: :comment
end
