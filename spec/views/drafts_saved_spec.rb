# frozen_string_literal: true

require "spec_helper"

describe "drafts/_saved", :type => :view do
  fixtures :drafts, :projects, :users, :issues, :trackers,
           :issue_statuses, :enumerations

  before do
    @draft = Draft.find(1) # element_id: 1 in fixtures
  end

  it "renders localStorage.removeItem with the correct draft key" do
    render partial: "drafts/saved"
    expect(rendered).to include("localStorage.removeItem")
    expect(rendered).to include("redmine_draft_issue_#{@draft.element_id}")
  end
end
