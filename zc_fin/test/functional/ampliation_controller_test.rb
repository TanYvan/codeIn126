require File.dirname(__FILE__) + '/../test_helper'
require 'ampliation_controller'

# Re-raise errors caught by the controller.
class AmpliationController; def rescue_action(e) raise e end; end

class AmpliationControllerTest < Test::Unit::TestCase
  def setup
    @controller = AmpliationController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
