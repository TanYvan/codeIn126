require File.dirname(__FILE__) + '/../test_helper'
require 'amount_total_controller'

# Re-raise errors caught by the controller.
class AmountTotalController; def rescue_action(e) raise e end; end

class AmountTotalControllerTest < Test::Unit::TestCase
  def setup
    @controller = AmountTotalController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
