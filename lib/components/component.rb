require 'dry-struct'

module Components
  module Types
    include Dry::Types.module
  end

  class Component < Dry::Struct
  end
end
