require File.dirname(__FILE__) + '/../test_helper'
require 'respondent_request_controller'

# Re-raise errors caught by the controller.
class RespondentRequestController; def rescue_action(e) raise e end; end

class RespondentRequestControllerTest < Test::Unit::TestCase
  def setup
    @controller = RespondentRequestController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
