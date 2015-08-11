require File.dirname(__FILE__) + '/../test_helper'
require 'casetype_endtype_count_controller'

# Re-raise errors caught by the controller.
class CasetypeEndtypeCountController; def rescue_action(e) raise e end; end

class CasetypeEndtypeCountControllerTest < Test::Unit::TestCase
  def setup
    @controller = CasetypeEndtypeCountController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
