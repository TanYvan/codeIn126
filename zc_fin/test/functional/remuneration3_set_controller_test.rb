require File.dirname(__FILE__) + '/../test_helper'
require 'remuneration3_set_controller'

# Re-raise errors caught by the controller.
class Remuneration3SetController; def rescue_action(e) raise e end; end

class Remuneration3SetControllerTest < Test::Unit::TestCase
  def setup
    @controller = Remuneration3SetController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
