require File.dirname(__FILE__) + '/../test_helper'
require 'limit_query_controller'

# Re-raise errors caught by the controller.
class LimitQueryController; def rescue_action(e) raise e end; end

class LimitQueryControllerTest < Test::Unit::TestCase
  def setup
    @controller = LimitQueryController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
