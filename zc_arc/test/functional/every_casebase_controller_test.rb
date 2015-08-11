require File.dirname(__FILE__) + '/../test_helper'
require 'every_casebase_controller'

# Re-raise errors caught by the controller.
class EveryCasebaseController; def rescue_action(e) raise e end; end

class EveryCasebaseControllerTest < Test::Unit::TestCase
  def setup
    @controller = EveryCasebaseController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
