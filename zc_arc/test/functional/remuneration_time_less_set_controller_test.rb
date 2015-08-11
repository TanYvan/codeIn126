require File.dirname(__FILE__) + '/../test_helper'
require 'remuneration_time_less_set_controller'

# Re-raise errors caught by the controller.
class RemunerationTimeLessSetController; def rescue_action(e) raise e end; end

class RemunerationTimeLessSetControllerTest < Test::Unit::TestCase
  def setup
    @controller = RemunerationTimeLessSetController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
