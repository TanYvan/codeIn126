require File.dirname(__FILE__) + '/../test_helper'
require 'respondent_agent_controller'

# Re-raise errors caught by the controller.
class RespondentAgentController; def rescue_action(e) raise e end; end

class RespondentAgentControllerTest < Test::Unit::TestCase
  def setup
    @controller = RespondentAgentController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
