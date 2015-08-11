require File.dirname(__FILE__) + '/../test_helper'
require 'casetype_endtype_workday_count_controller'

# Re-raise errors caught by the controller.
class CasetypeEndtypeWorkdayCountController; def rescue_action(e) raise e end; end

class CasetypeEndtypeWorkdayCountControllerTest < Test::Unit::TestCase
  def setup
    @controller = CasetypeEndtypeWorkdayCountController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
