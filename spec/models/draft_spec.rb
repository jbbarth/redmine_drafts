require "spec_helper"

describe "Draft" do
  fixtures :drafts

  it "should should be valid" do
    assert Draft.new.valid?
  end

  it "should nil content" do
    Draft.new.content.should == Hash.new
  end

  it "should find for issue" do
    assert Draft.find_for_issue(:element_id => 1, :user_id => 1).is_a?(Draft)
  end

  it "should find or create for issue" do
    assert_nil Draft.find_for_issue(:element_id => 3, :user_id => 1)
    draft = Draft.find_or_create_for_issue(:element_id => 3, :user_id => 1)
    assert draft.is_a?(Draft)
    assert draft.valid?
  end
end
