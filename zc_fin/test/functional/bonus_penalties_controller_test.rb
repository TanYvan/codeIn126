require File.dirname(__FILE__) + '/../test_helper'
require 'bonus_penalties_controller'

# Re-raise errors caught by the controller.
class BonusPenaltiesController; def rescue_action(e) raise e end; end

class BonusPenaltiesControllerTest < Test::Unit::TestCase
  def setup
    @controller = BonusPenaltiesController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
