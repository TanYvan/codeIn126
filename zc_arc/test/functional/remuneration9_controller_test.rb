require File.dirname(__FILE__) + '/../test_helper'
require 'remuneration9_controller'

# Re-raise errors caught by the controller.
class Remuneration9Controller; def rescue_action(e) raise e end; end

class Remuneration9ControllerTest < Test::Unit::TestCase
  def setup
    @controller = Remuneration9Controller.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
