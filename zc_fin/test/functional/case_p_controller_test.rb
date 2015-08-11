require File.dirname(__FILE__) + '/../test_helper'
require 'case_p_controller'

# Re-raise errors caught by the controller.
class CasePController; def rescue_action(e) raise e end; end

class CasePControllerTest < Test::Unit::TestCase
  def setup
    @controller = CasePController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
