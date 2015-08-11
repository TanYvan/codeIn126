require File.dirname(__FILE__) + '/../test_helper'
require 'case_consultation3_controller'

# Re-raise errors caught by the controller.
class CaseConsultation3Controller; def rescue_action(e) raise e end; end

class CaseConsultation3ControllerTest < Test::Unit::TestCase
  def setup
    @controller = CaseConsultation3Controller.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
