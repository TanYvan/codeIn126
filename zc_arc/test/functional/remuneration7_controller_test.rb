require File.dirname(__FILE__) + '/../test_helper'
require 'remuneration7_controller'

# Re-raise errors caught by the controller.
class Remuneration7Controller; def rescue_action(e) raise e end; end

class Remuneration7ControllerTest < Test::Unit::TestCase
  def setup
    @controller = Remuneration7Controller.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
