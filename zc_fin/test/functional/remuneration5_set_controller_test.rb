require File.dirname(__FILE__) + '/../test_helper'
require 'remuneration5_set_controller'

# Re-raise errors caught by the controller.
class Remuneration5SetController; def rescue_action(e) raise e end; end

class Remuneration5SetControllerTest < Test::Unit::TestCase
  def setup
    @controller = Remuneration5SetController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
