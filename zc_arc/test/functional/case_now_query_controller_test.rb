require File.dirname(__FILE__) + '/../test_helper'
require 'case_now_query_controller'

# Re-raise errors caught by the controller.
class CaseNowQueryController; def rescue_action(e) raise e end; end

class CaseNowQueryControllerTest < Test::Unit::TestCase
  def setup
    @controller = CaseNowQueryController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
