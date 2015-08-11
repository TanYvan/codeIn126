require File.dirname(__FILE__) + '/../test_helper'
require 'other_spend_controller'

# Re-raise errors caught by the controller.
class OtherSpendController; def rescue_action(e) raise e end; end

class OtherSpendControllerTest < Test::Unit::TestCase
  def setup
    @controller = OtherSpendController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
