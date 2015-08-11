require File.dirname(__FILE__) + '/../test_helper'
require 'remuneration23_controller'

# Re-raise errors caught by the controller.
class Remuneration23Controller; def rescue_action(e) raise e end; end

class Remuneration23ControllerTest < Test::Unit::TestCase
  def setup
    @controller = Remuneration23Controller.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
