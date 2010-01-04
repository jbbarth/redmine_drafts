class DraftsController < ApplicationController
  unloadable

  def create
    if request.xhr?
      @issue = Issue.find(params[:issue_id])
      lock_version = params[:issue][:lock_version].to_i
      @user = User.find(params[:user_id])
      @draft = Draft.find_for_issue(@issue,@user,lock_version)
      @draft ||= Draft.create(:user => @user, :element => @issue, :lock_version => lock_version)
      @draft.content = params.reject{|k,v| !%w(issue notes).include?(k)}
      if @draft.save
        render :partial => "saved", :layout => false
      end
    end
  end
end
