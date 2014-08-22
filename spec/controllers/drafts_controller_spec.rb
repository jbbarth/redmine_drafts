require "spec_helper"

describe DraftsController do
  fixtures :drafts, :issues, :users, :issue_statuses, :projects, :projects_trackers, :trackers, :enumerations

  before do
    @request.session[:user_id] = nil
    Setting.default_language = 'en'
  end

  it "should anonymous user cannot autosave a draft" do
    xhr :post, :autosave
    assert_response 401
  end

  it "should save draft for existing issue" do
    @request.session[:user_id] = 1
    xhr :post, :autosave,
              {:issue_id => 1,
               :user_id => 1,
               :issue => { :subject => "Changed the subject" },
               :notes => "Just a first try to add a note"
              }
    response.should be_success
    draft = Draft.find_for_issue(:element_id => 1, :user_id => 1)
    assert_not_nil draft
    draft.content.keys.sort.should == ["issue", "notes"]
    draft.content[:issue][:subject].should == "Changed the subject"

    xhr :post, :autosave,
              {:issue_id => 1,
               :notes => "Ok, let's change this note entirely and see if draft is duplicated",
               :user_id => 1,
               :issue => { :subject => "Changed the subject again !" }
              }
    (Draft.count(:conditions => {:element_type => 'Issue', :element_id => 1, :user_id => 1})).should == 1
    draft = Draft.find_for_issue(:element_id => 1, :user_id => 1)
    draft.content[:issue][:subject].should == "Changed the subject again !"
  end

  it "should save draft for existing issue with redmine 2 3 format" do
    @request.session[:user_id] = 1
    xhr :post, :autosave,
              { :issue_id => 1,
                :user_id => 1,
                :issue => {
                  :notes => "A note in Redmine 2.3.x structure!"
                }
              }
    response.should be_success
    draft = Draft.find_for_issue(:element_id => 1, :user_id => 1)
    assert_not_nil draft
    draft.content[:notes].should == "A note in Redmine 2.3.x structure!"
  end

  it "should save draft for new issue" do
    @request.session[:user_id] = 1
    xhr :post, :autosave,
              {:issue_id => 0,
               :user_id => 1,
               :issue => { :subject => "This is a totally new issue",
                           :description => "It has a description" },
              }
    response.should be_success
    draft = Draft.find_for_issue(:element_id => 0, :user_id => 1)
    assert_not_nil draft
    draft.content.keys.should == ["issue", "notes"]
    draft.content[:issue][:subject].should == "This is a totally new issue"
  end

  it "should clean draft after create" do
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

  it "should clean draft after update" do
    User.current = User.find(1)
    Draft.create(:element_type => 'Issue', :element_id => 1, :user_id => 1)
    assert_not_nil Draft.find_for_issue(:element_id => 1, :user_id => 1)
    Issue.find(1).save
    assert_nil Draft.find_for_issue(:element_id => 1, :user_id => 1)
  end
end
