module Components
  class ComponentGenerator < Rails::Generators::NamedBase
    desc 'Generate a component'

    source_root File.expand_path('../templates', __FILE__)

    def create_erb_file
      create_file "app/components/#{name}/_#{name}.html.erb"
    end

    def create_css_file
      create_file "app/components/#{name}/#{name}.css"
    end

    def create_js_file
      create_file "app/components/#{name}/#{name}.js"
    end

    def create_component_file
      template 'component.rb.erb', "app/components/#{name}/#{name}_component.rb"
    end
  end
end
