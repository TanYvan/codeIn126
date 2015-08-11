require File.dirname(__FILE__) + '/../test_helper'
require 'respondent_witness_controller'

# Re-raise errors caught by the controller.
class RespondentWitnessController; def rescue_action(e) raise e end; end

class RespondentWitnessControllerTest < Test::Unit::TestCase
  def setup
    @controller = RespondentWitnessController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
