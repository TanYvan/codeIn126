require File.dirname(__FILE__) + '/../test_helper'
require 'remuneration1_set_controller'

# Re-raise errors caught by the controller.
class Remuneration1SetController; def rescue_action(e) raise e end; end

class Remuneration1SetControllerTest < Test::Unit::TestCase
  def setup
    @controller = Remuneration1SetController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
