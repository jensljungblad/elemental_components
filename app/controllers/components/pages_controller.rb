module Components
  class PagesController < ApplicationController
    prepend_view_path 'app/styleguide'

    helper Rails.application.routes.url_helpers

    def show
      unless params[:path]
        params[:path] = Components.page_names[0][0]
      end
      render "pages/#{params[:path]}"
    end
  end
end
