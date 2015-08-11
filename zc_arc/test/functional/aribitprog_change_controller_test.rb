require File.dirname(__FILE__) + '/../test_helper'
require 'aribitprog_change_controller'

# Re-raise errors caught by the controller.
class AribitprogChangeController; def rescue_action(e) raise e end; end

class AribitprogChangeControllerTest < Test::Unit::TestCase
  def setup
    @controller = AribitprogChangeController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
