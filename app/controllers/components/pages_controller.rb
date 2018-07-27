module Components
  class PagesController < ActionController::Base
    def show
      render "/#{params[:path]}", layout: 'components/application'
    end
  end
end
