require File.dirname(__FILE__) + '/../test_helper'
require 'should_refund_check_2_controller'

# Re-raise errors caught by the controller.
class ShouldRefundCheck2Controller; def rescue_action(e) raise e end; end

class ShouldRefundCheck2ControllerTest < Test::Unit::TestCase
  def setup
    @controller = ShouldRefundCheck2Controller.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
