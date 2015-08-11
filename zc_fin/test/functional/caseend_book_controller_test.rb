require File.dirname(__FILE__) + '/../test_helper'
require 'caseend_book_controller'

# Re-raise errors caught by the controller.
class CaseendBookController; def rescue_action(e) raise e end; end

class CaseendBookControllerTest < Test::Unit::TestCase
  def setup
    @controller = CaseendBookController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
