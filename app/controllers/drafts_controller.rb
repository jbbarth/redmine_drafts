class DraftsController < ApplicationController
  unloadable

  def create
    if request.xhr? && !params[:notes].blank?
      @issue = Issue.find(params[:issue_id])
      version = params[:issue][:lock_version].to_i
      @user = User.find(params[:user_id])
      @draft = Draft.find_for_issue(@issue,@user,version)
      @draft ||= Draft.create(:user => @user, :element => @issue, :element_lock_version => version)
      @draft.content = params.reject{|k,v| !%w(issue notes).include?(k)}
      if @draft.save
        render :partial => "saved", :layout => false
      else
        render :text => "Error saving draft"
      end
    else
      render :nothing => true
    end
  end

  def restore
    @draft = Draft.find(params[:id])
    redirect_to({:controller => "issues", :action => "edit", :id => @draft.element_id}.merge(@draft.content))
  end
  
  def destroy
    @draft = Draft.find(params[:id])
    @draft.destroy
    render :nothing => true
  end
end
