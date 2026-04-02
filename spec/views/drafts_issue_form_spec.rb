# frozen_string_literal: true

require "spec_helper"

describe "drafts/_issue_form", :type => :view do
  fixtures :projects, :users, :user_preferences, :issues, :trackers,
           :issue_statuses, :enumerations

  before do
    @project = Project.find(1)
    @issue   = Issue.find(1)
    User.current = User.find(2) # a logged-in user
  end

  it "renders the localStorage draft key with the issue id" do
    render partial: "drafts/issue_form"
    expect(rendered).to include("redmine_draft_issue_#{@issue.id}")
  end

  it "renders the saveLocalDraft function targeting issue_notes" do
    render partial: "drafts/issue_form"
    expect(rendered).to include("saveLocalDraft")
    expect(rendered).to include("localStorage.setItem")
    expect(rendered).to include("issue_notes")
  end

  it "renders auto-restore logic on page load" do
    render partial: "drafts/issue_form"
    expect(rendered).to include("localStorage.getItem")
    expect(rendered).to include("draft-status")
    expect(rendered).to include("localDraft.notes !== notes.value")
  end

  it "renders the submit flag and timestamp for submission detection" do
    render partial: "drafts/issue_form"
    expect(rendered).to include("ISSUE_UPDATED_AT")
    expect(rendered).to include(@issue.updated_on.to_i.to_s)
    expect(rendered).to include("submitting")
    expect(rendered).to include("ISSUE_UPDATED_AT * 1000")
  end

  it "renders the AJAX fail handler with session expired warning" do
    render partial: "drafts/issue_form"
    expect(rendered).to include(".fail(")
    expect(rendered).to include("draft-session-warning")
    expect(rendered).to include("session")
  end

  it "does not render autosave JS for anonymous user" do
    User.current = User.anonymous
    render partial: "drafts/issue_form"
    expect(rendered).not_to include("observe(")
    expect(rendered).not_to include("localStorage")
  end
end
