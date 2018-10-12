require 'redcarpet'
require 'rouge'
require 'rouge/plugins/redcarpet'
require 'components/attributes'
require 'components/configuration'
require 'components/elements'
require 'components/element'
require 'components/component'
require 'components/markdown_handler'
require 'components/markdown_renderer'
require 'components/engine'

module Components
  def self.configuration
    @configuration ||= Configuration.new
  end

  def self.configure
    yield configuration
  end

  def self.components_path
    Rails.root.join('app', 'components')
  end

  def self.component_names
    Dir.chdir(components_path) do
      Dir.glob('**/*_component.rb').map do |component|
        component.chomp('_component.rb')
      end.sort
    end
  end

  def self.pages_path
    Rails.root.join('app', 'views', 'styleguide')
  end

  def self.page_names(path = nil)
    Dir.chdir(path || pages_path) do
      Dir.glob('*').sort.map do |item|
        [
          item.sub(/\..*/, ''),
          item.sub(/\..*/, '').sub(/[0-9]*_?/, '').titleize
        ].tap do |array|
          array << page_names(item) if File.directory?(item)
        end
      end
    end
  end
end
