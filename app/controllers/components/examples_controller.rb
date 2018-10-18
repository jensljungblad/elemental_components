module Components
  class ExamplesController < ApplicationController
    prepend_view_path 'app/styleguide'

    def show
      render inline: 'example', layout: 'example'
    end
  end
end
