require File.dirname(__FILE__) + '/../test_helper'
require 'remuneration6_set_controller'

# Re-raise errors caught by the controller.
class Remuneration6SetController; def rescue_action(e) raise e end; end

class Remuneration6SetControllerTest < Test::Unit::TestCase
  def setup
    @controller = Remuneration6SetController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
