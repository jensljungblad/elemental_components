module Components
  class MarkdownHandler
    class << self
      def call(template)
        source = erb.call(template)

        <<-SOURCE
          #{name}.render(begin;#{source};end).html_safe
        SOURCE
      end

      def render(template)
        markdown.render(template)
      end

      private

      def erb
        @erb ||= ActionView::Template.registered_template_handler(:erb)
      end

      def markdown
        @markdown ||= Redcarpet::Markdown.new(
          Components::MarkdownRenderer,
          autolink: true,
          tables: true,
          fenced_code_blocks: true
        )
      end
    end
  end
end
