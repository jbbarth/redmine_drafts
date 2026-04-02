# frozen_string_literal: true

require "spec_helper"

describe "UserPatch" do
  fixtures :users, :drafts

  it "should delete drafts when user is destroyed" do
    user = User.find(1)
    Draft.create!(element_type: "Issue", user_id: user.id, element_id: 10, content: "test")
    Draft.create!(element_type: "Issue", user_id: user.id, element_id: 11, content: "test2")

    expect do
      user.destroy
    end.to change { Draft.where(user_id: user.id).count }.to(0)
  end
end
