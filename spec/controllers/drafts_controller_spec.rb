require "spec_helper"

describe DraftsController, :type => :controller do
  fixtures :drafts, :issues, :users, :issue_statuses, :projects, :projects_trackers, :trackers, :enumerations

  before do
    @request.session[:user_id] = nil
    Setting.default_language = 'en'
  end

  it "should anonymous user cannot autosave a draft" do
    post :autosave, xhr: true
    assert_response 401
  end

  it "should save draft for existing issue" do
    @request.session[:user_id] = 1
    post :autosave, params: {:issue_id => 1,
               :user_id => 1,
               :issue => { :subject => "Changed the subject" },
               :notes => "Just a first try to add a note"
              }, xhr: true
    expect(response).to be_successful
    draft = Draft.find_for_issue(:element_id => 1, :user_id => 1)
    refute_nil draft
    expect(draft.content.keys.sort).to eq ["issue", "notes"]
    expect(draft.content[:issue][:subject]).to eq "Changed the subject"

    post :autosave, params: {:issue_id => 1,
               :notes => "Ok, let's change this note entirely and see if draft is duplicated",
               :user_id => 1,
               :issue => { :subject => "Changed the subject again !" }
              }, xhr: true
    expect(Draft.where(:element_type => 'Issue', :element_id => 1, :user_id => 1).count).to eq 1
    draft = Draft.find_for_issue(:element_id => 1, :user_id => 1)
    expect(draft.content[:issue][:subject]).to eq "Changed the subject again !"
  end

  it "should save draft for existing issue with redmine 2 3 format" do
    @request.session[:user_id] = 1
    post :autosave, params: { :issue_id => 1,
                :user_id => 1,
                :issue => {
                  :notes => "A note in Redmine 2.3.x structure!"
                }
              }, xhr: true
    expect(response).to be_successful
    draft = Draft.find_for_issue(:element_id => 1, :user_id => 1)
    refute_nil draft
    expect(draft.content[:notes]).to eq "A note in Redmine 2.3.x structure!"
  end

  it "should save draft for new issue" do
    @request.session[:user_id] = 1
    post :autosave, params: {:issue_id => 0,
               :user_id => 1,
               :issue => { :subject => "This is a totally new issue",
                           :description => "It has a description" },
              }, xhr: true
    expect(response).to be_successful
    draft = Draft.find_for_issue(:element_id => 0, :user_id => 1)
    refute_nil draft
    expect(draft.content.keys).to eq ["issue", "notes"]
    expect(draft.content[:issue][:subject]).to eq "This is a totally new issue"
  end

  it "should clean draft after create" do
    User.current=User.find(1)
    Draft.create(:element_type => 'Issue', :element_id => 0, :user_id => 1)
    refute_nil Draft.find_for_issue(:element_id => 0, :user_id => 1)
    issue = Issue.new(:project_id => 1, :tracker_id => 1, :author_id => 1,
              :status_id => 1, :priority => IssuePriority.all.first,
              :subject => 'test_clean_after_draft_create',
              :description => 'Draft cleaning after_create')
    expect(issue.save).to be_truthy
    expect(Draft.find_for_issue(:element_id => 0, :user_id => 1)).to be_nil
  end

  it "should clean draft after update" do
    User.current = User.find(1)
    Draft.create(:element_type => 'Issue', :element_id => 1, :user_id => 1)
    refute_nil Draft.find_for_issue(:element_id => 1, :user_id => 1)
    Issue.find(1).save
    expect(Draft.find_for_issue(:element_id => 1, :user_id => 1)).to be_nil
  end
end
