require File.dirname(__FILE__) + '/../test_helper'
require 'appraise_controller'

# Re-raise errors caught by the controller.
class AppraiseController; def rescue_action(e) raise e end; end

class AppraiseControllerTest < Test::Unit::TestCase
  def setup
    @controller = AppraiseController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
