# frozen_string_literal: true

module ElementalComponents
  module ComponentHelper
    def component(name, attrs = nil, &)
      "#{name}_component".classify.constantize.new(self, attrs, &).render
    end
  end
end
