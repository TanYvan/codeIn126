require File.dirname(__FILE__) + '/../test_helper'
require 'docformat_controller'

# Re-raise errors caught by the controller.
class DocformatController; def rescue_action(e) raise e end; end

class DocformatControllerTest < Test::Unit::TestCase
  def setup
    @controller = DocformatController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
