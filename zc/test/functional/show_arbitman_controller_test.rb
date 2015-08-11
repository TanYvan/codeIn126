require File.dirname(__FILE__) + '/../test_helper'
require 'show_arbitman_controller'

# Re-raise errors caught by the controller.
class ShowArbitmanController; def rescue_action(e) raise e end; end

class ShowArbitmanControllerTest < Test::Unit::TestCase
  def setup
    @controller = ShowArbitmanController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
