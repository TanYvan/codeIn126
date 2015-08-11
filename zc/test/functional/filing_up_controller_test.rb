require File.dirname(__FILE__) + '/../test_helper'
require 'filing_up_controller'

# Re-raise errors caught by the controller.
class FilingUpController; def rescue_action(e) raise e end; end

class FilingUpControllerTest < Test::Unit::TestCase
  def setup
    @controller = FilingUpController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
