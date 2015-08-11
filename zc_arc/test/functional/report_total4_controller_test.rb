require File.dirname(__FILE__) + '/../test_helper'
require 'report_total4_controller'

# Re-raise errors caught by the controller.
class ReportTotal4Controller; def rescue_action(e) raise e end; end

class ReportTotal4ControllerTest < Test::Unit::TestCase
  def setup
    @controller = ReportTotal4Controller.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
