require File.dirname(__FILE__) + '/../test_helper'
require 'refund_list_controller'

# Re-raise errors caught by the controller.
class RefundListController; def rescue_action(e) raise e end; end

class RefundListControllerTest < Test::Unit::TestCase
  def setup
    @controller = RefundListController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
