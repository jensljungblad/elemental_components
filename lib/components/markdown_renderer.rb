module Components
  class MarkdownRenderer < Redcarpet::Render::HTML
    include Rouge::Plugins::Redcarpet

    def block_code(code, language)
      case language
      when "example"
        options, code = parse_options(code)
        example(code, options)
      else
        super
      end
    end

    def example(code, options)
      <<-EXAMPLE
        <div class="example">
          <iframe src="/styleguide/example?example=#{Base64.urlsafe_encode64(code)}"
                  width="#{options['width'] || '100%'}"
                  height="#{options['height'] || 'auto'}"></iframe>
        </div>
        <div class="example-source">
          #{block_code(code.strip, 'erb')}
        </div>
      EXAMPLE
    end

    private

    def parse_options(code)
      pieces = code.split("---")

      if pieces.length > 1
        options = pieces[0].split("\n").map { |i| i.split(": ") }.to_h
        [options, pieces[1]]
      else
        options = {}
        [options, pieces[0]]
      end
    end
  end
end
