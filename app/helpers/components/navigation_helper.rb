module Components
  module NavigationHelper
    # rubocop:disable Metrics/MethodLength
    def navigation(pages = nil, paths = [])
      content_tag :ul do
        (pages || Components.page_names).map do |page|
          path, label, children = page
          path = paths.dup << path

          content_tag :li do
            if children
              [label, navigation(children, path)].join('').html_safe
            else
              link_to label, components.page_path(path)
            end
          end
        end.join('').html_safe
      end
    end
    # rubocop:enable Metrics/MethodLength
  end
end
