require File.dirname(__FILE__) + '/../test_helper'

class IssueDraftsTest < ActiveSupport::TestCase
  fixtures :users, :issues, :issue_statuses, :projects, :projects_trackers, :trackers, :enumerations

  def test_clean_drafts_on_create
    User.current = User.find(3)
    project = Project.first
    issue = Issue.new(:project => project, :author => User.current, :subject => 'test_create', :description => 'IssueTest#test_create',
                      :status => IssueStatus.first, :tracker => project.trackers.first, :priority => IssuePriority.first)
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
