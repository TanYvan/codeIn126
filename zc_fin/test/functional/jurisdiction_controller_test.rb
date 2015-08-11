require File.dirname(__FILE__) + '/../test_helper'
require 'jurisdiction_controller'

# Re-raise errors caught by the controller.
class JurisdictionController; def rescue_action(e) raise e end; end

class JurisdictionControllerTest < Test::Unit::TestCase
  def setup
    @controller = JurisdictionController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
