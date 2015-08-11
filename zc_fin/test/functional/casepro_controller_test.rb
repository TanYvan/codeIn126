require File.dirname(__FILE__) + '/../test_helper'
require 'casepro_controller'

# Re-raise errors caught by the controller.
class CaseproController; def rescue_action(e) raise e end; end

class CaseproControllerTest < Test::Unit::TestCase
  def setup
    @controller = CaseproController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
