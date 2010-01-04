class DraftsController < ApplicationController
  unloadable

  def create
    if request.xhr?
      @issue = Issue.find(params[:issue_id])
      @user = User.find(params[:user_id])
      @draft = Draft.find_for_issue(@issue,@user) || Draft.create(:user => @user, :element => @issue)
      @draft.content = params.reject{|k,v| !%w(issue notes).include?(k)}
      if @draft.save
        render :partial => "saved", :layout => false
      end
    end
  end
end
