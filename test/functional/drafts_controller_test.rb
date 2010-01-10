require File.dirname(__FILE__) + '/../test_helper'

class DraftsControllerTest < ActionController::TestCase
  def test_anonymous_user_cannot_create_a_draft
    xhr :post, :create
    assert_redirected_to '/login?back_url=http%3A%2F%2Ftest.host%2Fdrafts'
  end
end
