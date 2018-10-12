module Components
  class Configuration
    attr_writer :stylesheet_link_tags

    attr_writer :javascript_include_tags

    attr_writer :stylesheet_pack_tags

    attr_writer :javascript_pack_tags

    def stylesheet_link_tags
      @stylesheet_link_tags ||= ['application']
    end

    def javascript_include_tags
      @javascript_include_tags ||= ['application']
    end

    def stylesheet_pack_tags
      @stylesheet_pack_tags ||= []
    end

    def javascript_pack_tags
      @javascript_pack_tags ||= []
    end
  end
end
