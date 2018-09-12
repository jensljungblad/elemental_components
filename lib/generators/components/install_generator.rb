module Components
  class InstallGenerator < Rails::Generators::Base
    desc 'Install style guide'

    source_root File.expand_path('../templates', __FILE__)

    def create_style_guide
      directory 'styleguide', 'app/views/styleguide'
    end
  end
end
