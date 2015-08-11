require File.dirname(__FILE__) + '/../test_helper'
require 'case_query_1_controller'

# Re-raise errors caught by the controller.
class CaseQuery1Controller; def rescue_action(e) raise e end; end

class CaseQuery1ControllerTest < Test::Unit::TestCase
  def setup
    @controller = CaseQuery1Controller.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
