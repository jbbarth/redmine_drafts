require File.dirname(__FILE__) + '/../test_helper'

class DraftsTest < ActionController::IntegrationTest
  fixtures :drafts, :issues, :users
  
  def test_save_draft
    issue = Issue.find(1)
    user = User.find(1)

    log_user('admin', 'admin')
    get "/issues/1"
    assert_response :success
    
    xhr :post, '/drafts',
              {:issue_id => 1,
               :user_id => 1,
               :issue => { :lock_version => "8", 
                           :subject => "Changed the subject" },
               :notes => "Just a first try to add a note"
              }
    assert_response :success
    draft = Draft.find_for_issue(:element_id => issue, :user_id => user, :element_lock_version => 8)
    assert_not_nil draft
    assert_equal ["issue", "notes"], draft.content.keys.sort
    assert_equal "Changed the subject", draft.content[:issue][:subject]
    
    xhr :post, '/drafts',
              {:issue_id => 1,
               :notes => "Ok, let's change this note entirely but keep the same lock version",
               :user_id => 1,
               :issue => { :lock_version => "8",
                           :subject => "Changed the subject again !" }
              }
    assert_equal 1, Draft.count(:conditions => {:element_type => 'Issue', 
                                                :element_id => 1,
                                                :element_lock_version => 8,
                                                :user_id => 1})
    draft = Draft.find_for_issue(:element_id => issue, :user_id => user, :element_lock_version => 8)
    assert_equal "Changed the subject again !", draft.content[:issue][:subject]
  end
end
