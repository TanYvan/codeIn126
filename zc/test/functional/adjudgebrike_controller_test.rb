require File.dirname(__FILE__) + '/../test_helper'
require 'adjudgebrike_controller'

# Re-raise errors caught by the controller.
class AdjudgebrikeController; def rescue_action(e) raise e end; end

class AdjudgebrikeControllerTest < Test::Unit::TestCase
  def setup
    @controller = AdjudgebrikeController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
