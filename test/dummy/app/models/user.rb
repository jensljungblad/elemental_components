# frozen_string_literal: true

class User
  attr_reader :id, :name

  def initialize(id: nil, name: nil)
    @id = id
    @name = name
  end
end
