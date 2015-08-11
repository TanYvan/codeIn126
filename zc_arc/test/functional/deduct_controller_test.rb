require File.dirname(__FILE__) + '/../test_helper'
require 'deduct_controller'

# Re-raise errors caught by the controller.
class DeductController; def rescue_action(e) raise e end; end

class DeductControllerTest < Test::Unit::TestCase
  def setup
    @controller = DeductController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
