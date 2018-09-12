module Components
  class MarkdownRenderer < Redcarpet::Render::HTML
    include Rouge::Plugins::Redcarpet

    def parse_attrs(code)
      pieces = code.split('---')

      if pieces.length > 1
        attrs = pieces[0].split("\n").map { |i| i.split(': ') }.to_h
        [attrs, pieces[1]]
      else
        attrs = {}
        [attrs, pieces[0]]
      end
    end

    def block_code(code, language)
      if language == 'example'
        attrs, code = parse_attrs(code)

        <<-EXAMPLE
          <%= component "styleguide/example" do |c| %>
            <% c.example(width: #{attrs['width'] || 'nil'},
                         height: #{attrs['height'] || 'nil'}) do %>
              #{code}
            <% end %>
            <% c.example_source do %>
              #{super(code, 'erb')}
            <% end %>
          <% end %>
        EXAMPLE
      else
        super
      end
    end
  end
end
