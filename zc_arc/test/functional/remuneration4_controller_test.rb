require File.dirname(__FILE__) + '/../test_helper'
require 'remuneration4_controller'

# Re-raise errors caught by the controller.
class Remuneration4Controller; def rescue_action(e) raise e end; end

class Remuneration4ControllerTest < Test::Unit::TestCase
  def setup
    @controller = Remuneration4Controller.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
