require File.dirname(__FILE__) + '/../test_helper'
require 'lookfile_controller'

# Re-raise errors caught by the controller.
class LookfileController; def rescue_action(e) raise e end; end

class LookfileControllerTest < Test::Unit::TestCase
  def setup
    @controller = LookfileController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
