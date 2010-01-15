require File.dirname(__FILE__) + '/../test_helper'

class IssueDraftsTest < ActiveSupport::TestCase
  fixtures :users, :issues

  def test_clean_drafts_on_create
    User.current = User.find(3)
    issue = Issue.new(:project_id => 1, :tracker_id => 1, :author_id => 3, :status_id => 1, :priority => IssuePriority.all.first, :subject => 'test_create', :description => 'IssueTest#test_create')
    conds = {:user_id => 3, :element_id => 0}
    assert Draft.find_or_create_for_issue(conds).is_a?(Draft)
    assert_not_nil Draft.find_for_issue(conds)
    assert issue.save
    assert_nil Draft.find_for_issue(conds)
  end

  def test_clean_drafts_on_update
    issue = Issue.find(1)
    User.current = issue.author
    conds = {:user_id => issue.author.id, :element_id => issue.id}
    assert Draft.find_or_create_for_issue(conds).is_a?(Draft)
    assert_not_nil Draft.find_for_issue(conds)
    issue.subject = "Another wonderful subject"
    issue.save
    assert_nil Draft.find_for_issue(conds)
  end
end
