module Components
  class Engine < ::Rails::Engine
    isolate_namespace Components

    initializer 'components.asset_paths' do |app|
      app.config.assets.paths << Components.path
    end

    initializer 'components.autoload_paths', before: :set_autoload_paths do |app|
      app.config.autoload_paths += Dir["#{Components.path}/{*}"]
    end

    initializer 'components.view_context' do
      ActiveSupport.on_load :action_view do
        include Components::Context
      end
    end

    initializer 'components.view_helpers' do
      ActiveSupport.on_load :action_controller do
        helper Components::ComponentHelper
      end
    end

    initializer 'components.view_paths' do
      ActiveSupport.on_load :action_controller do
        append_view_path Components.path
      end
    end
  end
end
