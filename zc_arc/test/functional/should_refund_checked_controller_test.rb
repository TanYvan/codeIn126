require File.dirname(__FILE__) + '/../test_helper'
require 'should_refund_checked_controller'

# Re-raise errors caught by the controller.
class ShouldRefundCheckedController; def rescue_action(e) raise e end; end

class ShouldRefundCheckedControllerTest < Test::Unit::TestCase
  def setup
    @controller = ShouldRefundCheckedController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
