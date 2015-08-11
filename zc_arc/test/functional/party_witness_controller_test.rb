require File.dirname(__FILE__) + '/../test_helper'
require 'party_witness_controller'

# Re-raise errors caught by the controller.
class PartyWitnessController; def rescue_action(e) raise e end; end

class PartyWitnessControllerTest < Test::Unit::TestCase
  def setup
    @controller = PartyWitnessController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
