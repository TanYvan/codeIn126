require File.dirname(__FILE__) + '/../test_helper'
require 'caseorg_controller'

# Re-raise errors caught by the controller.
class CaseorgController; def rescue_action(e) raise e end; end

class CaseorgControllerTest < Test::Unit::TestCase
  def setup
    @controller = CaseorgController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
