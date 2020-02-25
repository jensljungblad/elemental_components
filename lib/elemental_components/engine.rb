# frozen_string_literal: true

module ElementalComponents
  class Engine < ::Rails::Engine
    isolate_namespace ElementalComponents

    initializer "elemental_components.asset_paths" do |app|
      app.config.assets.paths << ElementalComponents.components_path if app.config.respond_to?(:assets)
    end

    initializer "elemental_components.view_helpers" do
      ActiveSupport.on_load :action_controller do
        helper ElementalComponents::ComponentHelper
      end
    end

    initializer "elemental_components.view_paths" do
      ActiveSupport.on_load :action_controller do
        append_view_path ElementalComponents.components_path
      end
    end
  end
end
