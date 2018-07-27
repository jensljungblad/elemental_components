require 'redcarpet'
require 'rouge'
require 'rouge/plugins/redcarpet'

module Components
  class MarkdownRenderer < Redcarpet::Render::HTML
    include Rouge::Plugins::Redcarpet
  end
end
