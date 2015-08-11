require File.dirname(__FILE__) + '/../test_helper'
require 'casecomment_controller'

# Re-raise errors caught by the controller.
class CasecommentController; def rescue_action(e) raise e end; end

class CasecommentControllerTest < Test::Unit::TestCase
  def setup
    @controller = CasecommentController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
