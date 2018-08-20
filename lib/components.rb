require 'redcarpet'
require 'rouge'
require 'rouge/plugins/redcarpet'
require 'components/attributes'
require 'components/elements'
require 'components/element'
require 'components/component'
require 'components/markdown_handler'
require 'components/markdown_renderer'
require 'components/engine'

module Components
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
end
