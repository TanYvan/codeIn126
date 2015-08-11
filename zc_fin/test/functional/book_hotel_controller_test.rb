require File.dirname(__FILE__) + '/../test_helper'
require 'book_hotel_controller'

# Re-raise errors caught by the controller.
class BookHotelController; def rescue_action(e) raise e end; end

class BookHotelControllerTest < Test::Unit::TestCase
  def setup
    @controller = BookHotelController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
