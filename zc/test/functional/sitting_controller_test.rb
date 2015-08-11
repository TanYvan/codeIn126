require File.dirname(__FILE__) + '/../test_helper'
require 'sitting_controller'

# Re-raise errors caught by the controller.
class SittingController; def rescue_action(e) raise e end; end

class SittingControllerTest < Test::Unit::TestCase
  def setup
    @controller = SittingController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
