require File.dirname(__FILE__) + '/../test_helper'
require 'expire_check_controller'

# Re-raise errors caught by the controller.
class ExpireCheckController; def rescue_action(e) raise e end; end

class ExpireCheckControllerTest < Test::Unit::TestCase
  def setup
    @controller = ExpireCheckController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
