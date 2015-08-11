require File.dirname(__FILE__) + '/../test_helper'
require 'should_charge_query_controller'

# Re-raise errors caught by the controller.
class ShouldChargeQueryController; def rescue_action(e) raise e end; end

class ShouldChargeQueryControllerTest < Test::Unit::TestCase
  def setup
    @controller = ShouldChargeQueryController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
