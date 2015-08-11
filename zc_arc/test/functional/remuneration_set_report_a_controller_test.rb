require File.dirname(__FILE__) + '/../test_helper'
require 'remuneration_set_report_a_controller'

# Re-raise errors caught by the controller.
class RemunerationSetReportAController; def rescue_action(e) raise e end; end

class RemunerationSetReportAControllerTest < Test::Unit::TestCase
  def setup
    @controller = RemunerationSetReportAController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
