require File.dirname(__FILE__) + '/../test_helper'
require 'charge_recall_controller'

# Re-raise errors caught by the controller.
class ChargeRecallController; def rescue_action(e) raise e end; end

class ChargeRecallControllerTest < Test::Unit::TestCase
  def setup
    @controller = ChargeRecallController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
