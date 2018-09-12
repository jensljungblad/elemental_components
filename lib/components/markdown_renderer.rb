module Components
  class MarkdownRenderer < Redcarpet::Render::HTML
    include Rouge::Plugins::Redcarpet

    def block_code(code, language)
      case language
      when 'example'
        attrs, code = parse_attrs(code)
        example(code, attrs)
      else
        super
      end
    end

    def example(code, attrs)
      <<-EXAMPLE
        <%= component "styleguide/example" do |c| %>
          <% c.example(width: #{attrs['width'] || 'nil'},
                       height: #{attrs['height'] || 'nil'}) do %>
            #{code}
          <% end %>
          <% c.example_source do %>
            #{block_code(code, 'erb')}
          <% end %>
        <% end %>
      EXAMPLE
    end

    private

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
  end
end
