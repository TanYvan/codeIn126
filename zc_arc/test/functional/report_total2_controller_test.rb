require File.dirname(__FILE__) + '/../test_helper'
require 'report_total2_controller'

# Re-raise errors caught by the controller.
class ReportTotal2Controller; def rescue_action(e) raise e end; end

class ReportTotal2ControllerTest < Test::Unit::TestCase
  def setup
    @controller = ReportTotal2Controller.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
