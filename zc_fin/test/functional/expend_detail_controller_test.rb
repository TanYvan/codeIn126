require File.dirname(__FILE__) + '/../test_helper'
require 'expend_detail_controller'

# Re-raise errors caught by the controller.
class ExpendDetailController; def rescue_action(e) raise e end; end

class ExpendDetailControllerTest < Test::Unit::TestCase
  def setup
    @controller = ExpendDetailController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
