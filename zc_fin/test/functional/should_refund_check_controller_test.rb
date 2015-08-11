require File.dirname(__FILE__) + '/../test_helper'
require 'should_refund_check_controller'

# Re-raise errors caught by the controller.
class ShouldRefundCheckController; def rescue_action(e) raise e end; end

class ShouldRefundCheckControllerTest < Test::Unit::TestCase
  def setup
    @controller = ShouldRefundCheckController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
