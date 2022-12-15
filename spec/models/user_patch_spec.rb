require "spec_helper"
require File.dirname(__FILE__) + '/../../lib/redmine_drafts/user_patch'

describe "UserPatch" do
  fixtures :users

  it "should delete the draft in case of cascade deleting" do
    user = User.last
    Draft.create(:element_type =>  Issue, user_id: user.id, element_id: 1, content: 'test')
    Draft.create(:element_type =>  Issue, user_id: user.id, element_id: 2, content: 'MyText')
    
    expect do
      user.destroy
    end.to change{ Draft.count }.by(-2)
  end
end
