module Components
  class ComponentGenerator < Rails::Generators::NamedBase
    desc 'Generate a component'
    class_option :skip_css, type: :boolean, default: false
    class_option :skip_js, type: :boolean, default: false
    class_option :skip_md, type: :boolean, default: false

    source_root File.expand_path('../templates', __FILE__)

    def create_component_file
      template 'component.rb.erb', Components.components_path.join("#{name}_component.rb")
    end

    def create_erb_file
      create_file Components.components_path.join(name, "_#{name}.html.erb")
    end

    def create_css_file
      return if options['skip_css']
      create_file Components.components_path.join(name, "#{name}.css")
    end

    def create_js_file
      return if options['skip_js']
      create_file Components.components_path.join(name, "#{name}.js")
    end

    def create_md_file
      return if options['skip_md']
      template 'component.md.erb', Components.pages_path.join(
        Dir.new(Components.pages_path).find do |file|
          file =~ /[0-9]*_?components/
        end,
        "#{name}.md"
      )
    end
  end
end
