require File.dirname(__FILE__) + '/../test_helper'

class DraftTest < ActiveSupport::TestCase
  fixtures :drafts

  def test_should_be_valid
    assert Draft.new.valid?
  end
end
