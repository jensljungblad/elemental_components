require 'components/engine'
require 'components/component'
require 'components/context'

module Components
  def self.path
    Rails.root.join('app', 'components')
  end

  def self.component_names
    Dir.glob(path.join('*')).map do |component_dir|
      File.basename(component_dir)
    end
  end
end
