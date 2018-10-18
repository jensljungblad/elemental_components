module Components
  class MarkdownHandler
    class << self
      def call(template)
        erb_handler.erb_implementation.new(
          markdown_renderer.render(template.source)
        ).src
      end

      private

      def erb_handler
        @erb_handler ||= ActionView::Template.registered_template_handler(:erb)
      end

      def markdown_renderer
        @markdown_renderer ||= Redcarpet::Markdown.new(
          Components::MarkdownRenderer,
          autolink: true,
          tables: true,
          fenced_code_blocks: true
        )
      end
    end
  end
end
