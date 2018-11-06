module Components
  module ComponentHelper
    def component(name, attrs = {}, &block)
      "#{name}_component".classify.constantize.new(self, attrs, &block).render
    end
  end
end
