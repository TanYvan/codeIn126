require File.dirname(__FILE__) + '/../test_helper'
require 'case_personal_controller'

# Re-raise errors caught by the controller.
class CasePersonalController; def rescue_action(e) raise e end; end

class CasePersonalControllerTest < Test::Unit::TestCase
  def setup
    @controller = CasePersonalController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
