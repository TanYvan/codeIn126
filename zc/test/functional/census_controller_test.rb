require File.dirname(__FILE__) + '/../test_helper'
require 'census_controller'

# Re-raise errors caught by the controller.
class CensusController; def rescue_action(e) raise e end; end

class CensusControllerTest < Test::Unit::TestCase
  def setup
    @controller = CensusController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
