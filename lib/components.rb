require 'components/attributes'
require 'components/elements'
require 'components/element'
require 'components/component'
require 'components/markdown_handler'
require 'components/engine'

module Components
  def self.components_path
    Rails.root.join('app', 'components')
  end

  def self.styleguide_path
    Rails.root.join('app', 'styleguide')
  end

  def self.component_names
    Dir.chdir(path) do
      Dir.glob('**/*_component.rb').map do |component|
        component.chomp('_component.rb')
      end.sort
    end
  end
end
