require File.dirname(__FILE__) + '/../test_helper'
require 'casetype_count_controller'

# Re-raise errors caught by the controller.
class CasetypeCountController; def rescue_action(e) raise e end; end

class CasetypeCountControllerTest < Test::Unit::TestCase
  def setup
    @controller = CasetypeCountController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
