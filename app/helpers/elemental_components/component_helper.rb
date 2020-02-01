# frozen_string_literal: true

module ElementalComponents
  module ComponentHelper
    def component(name, attrs = nil, &block)
      "#{name}_component".classify.constantize.new(self, attrs, &block).render
    end
  end
end
