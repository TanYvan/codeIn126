require File.dirname(__FILE__) + '/../test_helper'
require 'expire_controller'

# Re-raise errors caught by the controller.
class ExpireController; def rescue_action(e) raise e end; end

class ExpireControllerTest < Test::Unit::TestCase
  def setup
    @controller = ExpireController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
