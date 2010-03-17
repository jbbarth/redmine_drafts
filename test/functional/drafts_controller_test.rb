require File.dirname(__FILE__) + '/../test_helper'

class DraftsControllerTest < ActionController::TestCase
  fixtures :drafts, :issues, :users

  def setup
    @controller = DraftsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    @request.session[:user_id] = nil
    Setting.default_language = 'en'
  end

  def test_anonymous_user_cannot_autosave_a_draft
    xhr :post, :autosave
    assert_redirected_to '/login?back_url=http%3A%2F%2Ftest.host%2Fdrafts%2Fautosave'
  end
  
  def test_save_draft_for_existing_issue
    @request.session[:user_id] = 1
    xhr :post, :autosave,
              {:issue_id => 1,
               :user_id => 1,
               :issue => { :subject => "Changed the subject" },
               :notes => "Just a first try to add a note"
              }
    assert_response :success
    draft = Draft.find_for_issue(:element_id => 1, :user_id => 1)
    assert_not_nil draft
    assert_equal ["issue", "notes"], draft.content.keys.sort
    assert_equal "Changed the subject", draft.content[:issue][:subject]
    
    xhr :post, :autosave,
              {:issue_id => 1,
               :notes => "Ok, let's change this note entirely and see if draft is duplicated",
               :user_id => 1,
               :issue => { :subject => "Changed the subject again !" }
              }
    assert_equal 1, Draft.count(:conditions => {:element_type => 'Issue', 
                                                :element_id => 1,
                                                :user_id => 1})
    draft = Draft.find_for_issue(:element_id => 1, :user_id => 1)
    assert_equal "Changed the subject again !", draft.content[:issue][:subject]
  end
  
  def test_save_draft_for_new_issue
    @request.session[:user_id] = 1
    xhr :post, :autosave,
              {:issue_id => 0,
               :user_id => 1,
               :issue => { :subject => "This is a totally new issue",
                           :description => "It has a description" },
              }
    assert_response :success
    draft = Draft.find_for_issue(:element_id => 0, :user_id => 1)
    assert_not_nil draft
    assert_equal ["issue"], draft.content.keys
    assert_equal "This is a totally new issue", draft.content[:issue][:subject]
  end

  def test_clean_draft_after_create
    User.current=User.find(1)
    Draft.create(:element_type => 'Issue', :element_id => 0, :user_id => 1)
    assert_not_nil Draft.find_for_issue(:element_id => 0, :user_id => 1)
    issue = Issue.new(:project_id => 1, :tracker_id => 1, :author_id => 1,
              :status_id => 1, :priority => IssuePriority.all.first, 
              :subject => 'test_clean_after_draft_create', 
              :description => 'Draft cleaning after_create')
    assert issue.save
    assert_nil Draft.find_for_issue(:element_id => 0, :user_id => 1)
  end
    
  def test_clean_draft_after_update
    User.current=User.find(1)
    assert_not_nil Draft.find_for_issue(:element_id => 1, :user_id => 1)
    Issue.find(1).save
    assert_nil Draft.find_for_issue(:element_id => 1, :user_id => 1)
  end
end
