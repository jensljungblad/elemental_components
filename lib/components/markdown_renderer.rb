module Components
  class MarkdownRenderer < Redcarpet::Render::HTML
    include Rouge::Plugins::Redcarpet

    def block_code(code, language)
      if language == 'example'
        "<div>#{code}</div><div>#{super(code, 'erb')}</div>"
      else
        super
      end
    end
  end
end
