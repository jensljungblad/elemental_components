require 'dry-struct'

module Components
  module Types
    include Dry::Types.module
  end

  class Component < Dry::Struct
    constructor_type :strict_with_defaults
  end
end
