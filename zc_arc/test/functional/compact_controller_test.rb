require File.dirname(__FILE__) + '/../test_helper'
require 'compact_controller'

# Re-raise errors caught by the controller.
class CompactController; def rescue_action(e) raise e end; end

class CompactControllerTest < Test::Unit::TestCase
  def setup
    @controller = CompactController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
