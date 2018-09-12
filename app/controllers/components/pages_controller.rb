module Components
  class PagesController < ApplicationController
    def show
      unless params[:path]
        params[:path] = Components.page_names[0][0]
      end
      render "styleguide/#{params[:path]}"
    end
  end
end
