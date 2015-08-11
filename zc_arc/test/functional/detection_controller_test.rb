require File.dirname(__FILE__) + '/../test_helper'
require 'detection_controller'

# Re-raise errors caught by the controller.
class DetectionController; def rescue_action(e) raise e end; end

class DetectionControllerTest < Test::Unit::TestCase
  def setup
    @controller = DetectionController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
