# frozen_string_literal: true

module ElementalComponents
  class ComponentGenerator < Rails::Generators::NamedBase
    desc "Generate a component"
    class_option :skip_erb, type: :boolean, default: false
    class_option :skip_css, type: :boolean, default: false

    source_root File.expand_path("templates", __dir__)

    def create_component_file
      template "component.rb.erb", "app/components/#{name}_component.rb"
    end

    def create_erb_file
      return if options["skip_erb"]

      create_file "app/components/#{name}/_#{filename}.html.erb"
    end

    def create_css_file
      return if options["skip_css"]

      create_file "app/components/#{name}/#{filename}.css"
    end

    private

    def filename
      name.split("/").last
    end
  end
end
