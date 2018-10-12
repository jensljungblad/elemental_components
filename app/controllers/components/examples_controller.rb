module Components
  class ExamplesController < ApplicationController
    def show
      render inline: 'example', layout: 'styleguide_example'
    end
  end
end
