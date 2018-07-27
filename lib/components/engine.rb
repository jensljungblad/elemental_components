module Components
  class Engine < ::Rails::Engine
    isolate_namespace Components

    initializer 'components.asset_paths' do |app|
      app.config.assets.paths << Components.components_path
    end

    initializer 'components.view_helpers' do
      ActiveSupport.on_load :action_controller do
        helper Components::ComponentHelper
      end
    end

    initializer 'components.view_paths' do
      ActiveSupport.on_load :action_controller do
        append_view_path Components.components_path
        append_view_path Components.styleguide_path
      end
    end

    initializer 'components.template_hander' do
      ActionView::Template.register_template_handler :md, MarkdownHandler
    end
  end
end
