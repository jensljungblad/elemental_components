module Components
  class MarkdownRenderer < Redcarpet::Render::HTML
    include Rouge::Plugins::Redcarpet

    def block_code(code, language)
      if language == 'example'
        <<-EXAMPLE
          <%= component "styleguide/example" do |c| %>
            <% c.example do %>
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
