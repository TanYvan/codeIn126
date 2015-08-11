require File.dirname(__FILE__) + '/../test_helper'
require 'case_transfer_controller'

# Re-raise errors caught by the controller.
class CaseTransferController; def rescue_action(e) raise e end; end

class CaseTransferControllerTest < Test::Unit::TestCase
  def setup
    @controller = CaseTransferController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
