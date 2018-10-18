module Components
  class ComponentGenerator < Rails::Generators::NamedBase
    desc 'Generate a component'
    class_option :skip_css, type: :boolean, default: false
    class_option :skip_js, type: :boolean, default: false
    class_option :skip_md, type: :boolean, default: false

    source_root File.expand_path('../templates', __FILE__)

    def create_component_file
      template 'component.rb.erb', "app/components/#{name}_component.rb"
    end

    def create_erb_file
      create_file "app/components/#{name}/_#{name}.html.erb"
    end

    def create_css_file
      return if options['skip_css']
      create_file "app/components/#{name}/#{name}.css"
    end

    def create_js_file
      return if options['skip_js']
      create_file "app/components/#{name}/#{name}.js"
    end

    def create_md_file
      return if options['skip_md']

      style_guide_path = File.join(destination_root, 'app/styleguide/pages')

      raise 'No app/styleguide/pages directory found' unless Dir.exist?(style_guide_path)

      components_path = Dir.new(style_guide_path).find do |file|
        file =~ /[0-9]*_?components/
      end

      raise 'No app/styleguide/pages/components directory found' unless components_path

      template 'component.md.erb', File.join(style_guide_path, components_path, "#{name}.md")
    end
  end
end
