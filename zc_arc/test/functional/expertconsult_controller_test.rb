require File.dirname(__FILE__) + '/../test_helper'
require 'expertconsult_controller'

# Re-raise errors caught by the controller.
class ExpertconsultController; def rescue_action(e) raise e end; end

class ExpertconsultControllerTest < Test::Unit::TestCase
  def setup
    @controller = ExpertconsultController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
