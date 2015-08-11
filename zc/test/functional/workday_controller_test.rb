require File.dirname(__FILE__) + '/../test_helper'
require 'workday_controller'

# Re-raise errors caught by the controller.
class WorkdayController; def rescue_action(e) raise e end; end

class WorkdayControllerTest < Test::Unit::TestCase
  def setup
    @controller = WorkdayController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
