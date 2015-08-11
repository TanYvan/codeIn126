require File.dirname(__FILE__) + '/../test_helper'
require 'case_list_controller'

# Re-raise errors caught by the controller.
class CaseListController; def rescue_action(e) raise e end; end

class CaseListControllerTest < Test::Unit::TestCase
  def setup
    @controller = CaseListController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
