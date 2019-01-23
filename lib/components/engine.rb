module Components
  class Engine < ::Rails::Engine
    isolate_namespace Components

    initializer "components.asset_paths" do |app|
      app.config.assets.paths << Components.components_path if app.config.respond_to?(:assets)
    end

    initializer "components.view_helpers" do
      ActiveSupport.on_load :action_controller do
        helper Components::ComponentHelper
      end
    end

    initializer "components.view_paths" do
      ActiveSupport.on_load :action_controller do
        append_view_path Components.components_path
      end
    end
  end
end
