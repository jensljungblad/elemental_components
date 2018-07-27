module Components
  class PagesController < ActionController::Base
    def show
      render "styleguide/#{params[:path]}", layout: 'components/application'
    end
  end
end
