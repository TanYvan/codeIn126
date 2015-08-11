require File.dirname(__FILE__) + '/../test_helper'
require 'remuneration4_set_controller'

# Re-raise errors caught by the controller.
class Remuneration4SetController; def rescue_action(e) raise e end; end

class Remuneration4SetControllerTest < Test::Unit::TestCase
  def setup
    @controller = Remuneration4SetController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
