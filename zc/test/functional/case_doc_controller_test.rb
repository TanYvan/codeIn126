require File.dirname(__FILE__) + '/../test_helper'
require 'case_doc_controller'

# Re-raise errors caught by the controller.
class CaseDocController; def rescue_action(e) raise e end; end

class CaseDocControllerTest < Test::Unit::TestCase
  def setup
    @controller = CaseDocController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
