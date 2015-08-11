require File.dirname(__FILE__) + '/../test_helper'
require 'award_controller'

# Re-raise errors caught by the controller.
class AwardController; def rescue_action(e) raise e end; end

class AwardControllerTest < Test::Unit::TestCase
  def setup
    @controller = AwardController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
