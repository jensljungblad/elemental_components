require 'test_helper'

module Components
  class Test < ActiveSupport::TestCase
    test 'truth' do
      assert_kind_of Module, Components
    end
  end
end
