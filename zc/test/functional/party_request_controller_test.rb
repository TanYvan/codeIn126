require File.dirname(__FILE__) + '/../test_helper'
require 'party_request_controller'

# Re-raise errors caught by the controller.
class PartyRequestController; def rescue_action(e) raise e end; end

class PartyRequestControllerTest < Test::Unit::TestCase
  def setup
    @controller = PartyRequestController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
