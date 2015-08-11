require File.dirname(__FILE__) + '/../test_helper'
require 'respondent_answer_controller'

# Re-raise errors caught by the controller.
class RespondentAnswerController; def rescue_action(e) raise e end; end

class RespondentAnswerControllerTest < Test::Unit::TestCase
  def setup
    @controller = RespondentAnswerController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
