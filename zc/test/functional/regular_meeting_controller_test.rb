require File.dirname(__FILE__) + '/../test_helper'
require 'regular_meeting_controller'

# Re-raise errors caught by the controller.
class RegularMeetingController; def rescue_action(e) raise e end; end

class RegularMeetingControllerTest < Test::Unit::TestCase
  def setup
    @controller = RegularMeetingController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
