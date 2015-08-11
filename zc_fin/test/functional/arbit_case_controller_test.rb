require File.dirname(__FILE__) + '/../test_helper'
require 'arbit_case_controller'

# Re-raise errors caught by the controller.
class ArbitCaseController; def rescue_action(e) raise e end; end

class ArbitCaseControllerTest < Test::Unit::TestCase
  def setup
    @controller = ArbitCaseController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
