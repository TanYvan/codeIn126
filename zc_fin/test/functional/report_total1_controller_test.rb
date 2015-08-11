require File.dirname(__FILE__) + '/../test_helper'
require 'report_total_1_controller'

# Re-raise errors caught by the controller.
class ReportTotal1Controller; def rescue_action(e) raise e end; end

class ReportTotal1ControllerTest < Test::Unit::TestCase
  def setup
    @controller = ReportTotal1Controller.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
