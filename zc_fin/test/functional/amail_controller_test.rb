require File.dirname(__FILE__) + '/../test_helper'
require 'amail_controller'

# Re-raise errors caught by the controller.
class AmailController; def rescue_action(e) raise e end; end

class AmailControllerTest < Test::Unit::TestCase
  def setup
    @controller = AmailController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
