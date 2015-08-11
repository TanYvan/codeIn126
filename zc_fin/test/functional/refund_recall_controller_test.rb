require File.dirname(__FILE__) + '/../test_helper'
require 'refund_recall_controller'

# Re-raise errors caught by the controller.
class RefundRecallController; def rescue_action(e) raise e end; end

class RefundRecallControllerTest < Test::Unit::TestCase
  def setup
    @controller = RefundRecallController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
