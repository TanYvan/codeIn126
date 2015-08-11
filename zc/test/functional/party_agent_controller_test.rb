require File.dirname(__FILE__) + '/../test_helper'
require 'party_agent_controller'

# Re-raise errors caught by the controller.
class PartyAgentController; def rescue_action(e) raise e end; end

class PartyAgentControllerTest < Test::Unit::TestCase
  def setup
    @controller = PartyAgentController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
