require File.dirname(__FILE__) + '/../test_helper'
require 'case_query_controller'

# Re-raise errors caught by the controller.
class CaseQueryController; def rescue_action(e) raise e end; end

class CaseQueryControllerTest < Test::Unit::TestCase
  def setup
    @controller = CaseQueryController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
