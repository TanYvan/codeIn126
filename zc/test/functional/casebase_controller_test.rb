require File.dirname(__FILE__) + '/../test_helper'
require 'casebase_controller'

# Re-raise errors caught by the controller.
class CasebaseController; def rescue_action(e) raise e end; end

class CasebaseControllerTest < Test::Unit::TestCase
  def setup
    @controller = CasebaseController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
