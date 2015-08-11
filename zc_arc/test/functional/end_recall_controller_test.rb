require File.dirname(__FILE__) + '/../test_helper'
require 'end_recall_controller'

# Re-raise errors caught by the controller.
class EndRecallController; def rescue_action(e) raise e end; end

class EndRecallControllerTest < Test::Unit::TestCase
  def setup
    @controller = EndRecallController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
