require File.dirname(__FILE__) + '/../test_helper'
require 'show_tax_controller'

# Re-raise errors caught by the controller.
class ShowTaxController; def rescue_action(e) raise e end; end

class ShowTaxControllerTest < Test::Unit::TestCase
  def setup
    @controller = ShowTaxController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
