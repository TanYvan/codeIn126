require File.dirname(__FILE__) + '/../test_helper'
require 'respondent_controller'

# Re-raise errors caught by the controller.
class RespondentController; def rescue_action(e) raise e end; end

class RespondentControllerTest < Test::Unit::TestCase
  def setup
    @controller = RespondentController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
