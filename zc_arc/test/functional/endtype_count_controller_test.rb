require File.dirname(__FILE__) + '/../test_helper'
require 'endtype_count_controller'

# Re-raise errors caught by the controller.
class EndtypeCountController; def rescue_action(e) raise e end; end

class EndtypeCountControllerTest < Test::Unit::TestCase
  def setup
    @controller = EndtypeCountController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
