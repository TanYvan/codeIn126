require File.dirname(__FILE__) + '/../test_helper'
require 'arbithotel_controller'

# Re-raise errors caught by the controller.
class ArbithotelController; def rescue_action(e) raise e end; end

class ArbithotelControllerTest < Test::Unit::TestCase
  def setup
    @controller = ArbithotelController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
