require File.dirname(__FILE__) + '/../test_helper'
require 'arbit_party_controller'

# Re-raise errors caught by the controller.
class ArbitPartyController; def rescue_action(e) raise e end; end

class ArbitPartyControllerTest < Test::Unit::TestCase
  def setup
    @controller = ArbitPartyController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
