require File.dirname(__FILE__) + '/../test_helper'
require 'remuneration_sum_controller'

# Re-raise errors caught by the controller.
class RemunerationSumController; def rescue_action(e) raise e end; end

class RemunerationSumControllerTest < Test::Unit::TestCase
  def setup
    @controller = RemunerationSumController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
