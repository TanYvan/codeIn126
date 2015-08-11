require File.dirname(__FILE__) + '/../test_helper'
require 'show_extend_controller'

# Re-raise errors caught by the controller.
class ShowExtendController; def rescue_action(e) raise e end; end

class ShowExtendControllerTest < Test::Unit::TestCase
  def setup
    @controller = ShowExtendController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
