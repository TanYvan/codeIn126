require File.dirname(__FILE__) + '/../test_helper'
require 'charge_correspondence_detail_controller'

# Re-raise errors caught by the controller.
class ChargeCorrespondenceDetailController; def rescue_action(e) raise e end; end

class ChargeCorrespondenceDetailControllerTest < Test::Unit::TestCase
  def setup
    @controller = ChargeCorrespondenceDetailController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
