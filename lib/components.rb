# frozen_string_literal: true

require "components/element"
require "components/component"
require "components/engine"

module Components
  class Error < StandardError; end

  def self.components_path
    Rails.root.join("app", "components")
  end

  def self.component_names
    Dir.chdir(components_path) do
      Dir.glob("**/*_component.rb").map { |component| component.chomp("_component.rb") }.sort
    end
  end
end
