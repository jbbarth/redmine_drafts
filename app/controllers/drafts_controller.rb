class DraftsController < ApplicationController
  unloadable
  
  before_filter :require_login

  def create
    if request.xhr? && !params[:notes].blank?
      @draft = Draft.find_or_create_for_issue(:user_id => params[:user_id].to_i,
                                              :element_id => params[:issue_id].to_i,
                                              :element_lock_version => params[:issue][:lock_version].to_i)
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
