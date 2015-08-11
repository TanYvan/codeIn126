require File.dirname(__FILE__) + '/../test_helper'
require 'census9_controller'

# Re-raise errors caught by the controller.
class Census9Controller; def rescue_action(e) raise e end; end

class Census9ControllerTest < Test::Unit::TestCase
  def setup
    @controller = Census9Controller.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
