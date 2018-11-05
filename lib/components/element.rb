module Components
  class Element
    include Attributes
    include Elements

    attr_reader :content

    def initialize(view, attributes = nil, &block)
      @view = view
      initialize_attributes(attributes)
      initialize_elements
      initialize_content(&block)
    end

    def serialize
      serialize_attributes
        .merge(serialize_elements)
        .merge(serialize_content)
    end

    protected

    # TODO: move block things to its own module as well? perhaps wait
    # until we know what to call it.. or move everything in here and
    # remove the modules altogether...
    def initialize_content(&block)
      @content = @view.capture(self, &block) if block
    end

    def serialize_content
      { content: content }
    end
  end
end
