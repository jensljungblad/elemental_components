module Components
  class Engine < ::Rails::Engine
    isolate_namespace Components

    initializer 'components.asset_paths' do |app|
      app.config.assets.paths << Components.components_path
      app.config.assets.paths << Components::Engine.root.join('app', 'components')
    end

    initializer 'components.view_helpers' do
      ActiveSupport.on_load :action_controller do
        helper Components::ComponentHelper
      end
    end

    initializer 'components.view_paths' do
      ActiveSupport.on_load :action_controller do
        append_view_path Components.components_path
        append_view_path Components::Engine.root.join('app', 'components')
      end
    end

    initializer 'components.template_hander' do
      ActionView::Template.register_template_handler :md, Components::MarkdownHandler
    end
  end
end
