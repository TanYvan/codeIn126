require File.dirname(__FILE__) + '/../test_helper'
require 'finance_balance_controller'

# Re-raise errors caught by the controller.
class FinanceBalanceController; def rescue_action(e) raise e end; end

class FinanceBalanceControllerTest < Test::Unit::TestCase
  def setup
    @controller = FinanceBalanceController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
