require_dependency 'issues_controller'

class IssuesController
  prepend_before_filter :set_draft

  private
  def set_draft
    if params[:draft_id]
      draft = Draft.find(params[:draft_id]) rescue nil
      if draft
        params.merge!(draft.content)
        #Redmine 2.1.x had params[:notes] while Redmine 2.2.x moved it to
        #params[:issue][:notes] when introducing private notes. We want to
        #support both formats so we need to save and restore at both places.
        params[:issue] ||= {}
        params[:notes] = params[:issue][:notes] if params[:notes].blank?
        params[:issue][:notes] = params[:notes] if params[:issue][:notes].blank?
      end
    end
    true
  end
end

