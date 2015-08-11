require File.dirname(__FILE__) + '/../test_helper'
require 't_extend_controller'

# Re-raise errors caught by the controller.
class TExtendController; def rescue_action(e) raise e end; end

class TExtendControllerTest < Test::Unit::TestCase
  def setup
    @controller = TExtendController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
