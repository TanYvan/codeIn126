require File.dirname(__FILE__) + '/../test_helper'
require 'clerk_change_cz_controller'

# Re-raise errors caught by the controller.
class ClerkChangeCzController; def rescue_action(e) raise e end; end

class ClerkChangeCzControllerTest < Test::Unit::TestCase
  def setup
    @controller = ClerkChangeCzController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
