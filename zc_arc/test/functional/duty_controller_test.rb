require File.dirname(__FILE__) + '/../test_helper'
require 'duty_controller'

# Re-raise errors caught by the controller.
class DutyController; def rescue_action(e) raise e end; end

class DutyControllerTest < Test::Unit::TestCase
  def setup
    @controller = DutyController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
