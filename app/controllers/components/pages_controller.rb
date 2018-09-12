module Components
  class PagesController < ApplicationController
    def show
      render "styleguide/#{params[:path]}"
    end
  end
end
