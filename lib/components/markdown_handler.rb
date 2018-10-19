module Components
  class MarkdownHandler
    class << self
      def call(template)
        @markdown_renderer ||= Redcarpet::Markdown.new(
          Components::MarkdownRenderer,
          autolink: true,
          tables: true,
          fenced_code_blocks: true
        )
        "#{@markdown_renderer.render(template.source).inspect}.html_safe"
      end
    end
  end
end
