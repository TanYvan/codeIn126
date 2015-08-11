require File.dirname(__FILE__) + '/../test_helper'
require 'remuneration_time_less_controller'

# Re-raise errors caught by the controller.
class RemunerationTimeLessController; def rescue_action(e) raise e end; end

class RemunerationTimeLessControllerTest < Test::Unit::TestCase
  def setup
    @controller = RemunerationTimeLessController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
