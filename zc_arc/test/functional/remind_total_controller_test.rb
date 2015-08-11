require File.dirname(__FILE__) + '/../test_helper'
require 'remind_total_controller'

# Re-raise errors caught by the controller.
class RemindTotalController; def rescue_action(e) raise e end; end

class RemindTotalControllerTest < Test::Unit::TestCase
  def setup
    @controller = RemindTotalController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
