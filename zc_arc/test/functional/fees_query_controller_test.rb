require File.dirname(__FILE__) + '/../test_helper'
require 'fees_query_controller'

# Re-raise errors caught by the controller.
class FeesQueryController; def rescue_action(e) raise e end; end

class FeesQueryControllerTest < Test::Unit::TestCase
  def setup
    @controller = FeesQueryController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
