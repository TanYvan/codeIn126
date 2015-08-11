require File.dirname(__FILE__) + '/../test_helper'
require 'case_consultation2_controller'

# Re-raise errors caught by the controller.
class CaseConsultation2Controller; def rescue_action(e) raise e end; end

class CaseConsultation2ControllerTest < Test::Unit::TestCase
  def setup
    @controller = CaseConsultation2Controller.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
