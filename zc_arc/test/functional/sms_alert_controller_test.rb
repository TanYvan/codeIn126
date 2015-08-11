require File.dirname(__FILE__) + '/../test_helper'
require 'sms_alert_controller'

# Re-raise errors caught by the controller.
class SmsAlertController; def rescue_action(e) raise e end; end

class SmsAlertControllerTest < Test::Unit::TestCase
  def setup
    @controller = SmsAlertController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
