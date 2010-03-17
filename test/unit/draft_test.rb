require File.dirname(__FILE__) + '/../test_helper'

class DraftTest < ActiveSupport::TestCase
  fixtures :drafts

  def test_should_be_valid
    assert Draft.new.valid?
  end

  def test_nil_content
    assert_equal Hash.new, Draft.new.content
  end

  def test_find_for_issue
    assert Draft.find_for_issue(:element_id => 1, :user_id => 1).is_a?(Draft)
  end

  def test_find_or_create_for_issue
    assert_nil Draft.find_for_issue(:element_id => 3, :user_id => 1)
    draft = Draft.find_or_create_for_issue(:element_id => 3, :user_id => 1)
    assert draft.is_a?(Draft)
    assert draft.valid?
  end
end
