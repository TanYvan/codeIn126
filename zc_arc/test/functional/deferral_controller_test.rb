require File.dirname(__FILE__) + '/../test_helper'
require 'deferral_controller'

# Re-raise errors caught by the controller.
class DeferralController; def rescue_action(e) raise e end; end

class DeferralControllerTest < Test::Unit::TestCase
  def setup
    @controller = DeferralController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
