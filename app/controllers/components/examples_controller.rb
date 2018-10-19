module Components
  class ExamplesController < ApplicationController
    prepend_view_path 'app/styleguide'

    helper Rails.application.helpers
    helper Rails.application.routes.url_helpers

    def show
      render inline: Base64.urlsafe_decode64(params[:example]), layout: 'example'
    end
  end
end
