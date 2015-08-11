require File.dirname(__FILE__) + '/../test_helper'
require 'expert_meeting_controller'

# Re-raise errors caught by the controller.
class ExpertMeetingController; def rescue_action(e) raise e end; end

class ExpertMeetingControllerTest < Test::Unit::TestCase
  def setup
    @controller = ExpertMeetingController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
