require File.dirname(__FILE__) + '/../test_helper'
require 'clerk_change_controller'

# Re-raise errors caught by the controller.
class ClerkChangeController; def rescue_action(e) raise e end; end

class ClerkChangeControllerTest < Test::Unit::TestCase
  def setup
    @controller = ClerkChangeController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
