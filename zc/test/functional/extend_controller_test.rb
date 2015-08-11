require File.dirname(__FILE__) + '/../test_helper'
require 'extend_controller'

# Re-raise errors caught by the controller.
class ExtendController; def rescue_action(e) raise e end; end

class ExtendControllerTest < Test::Unit::TestCase
  def setup
    @controller = ExtendController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
