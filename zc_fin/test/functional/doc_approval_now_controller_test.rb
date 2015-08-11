require File.dirname(__FILE__) + '/../test_helper'
require 'doc_approval_now_controller'

# Re-raise errors caught by the controller.
class DocApprovalNowController; def rescue_action(e) raise e end; end

class DocApprovalNowControllerTest < Test::Unit::TestCase
  def setup
    @controller = DocApprovalNowController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
