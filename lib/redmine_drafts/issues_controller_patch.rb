require_dependency 'issues_controller'

module RedmineDrafts::IssuesControllerPatch
  def set_draft
    if params[:draft_id].present?
      draft = Draft.find(params[:draft_id]) rescue nil
      if draft.present?
        params.merge!(draft.content.permit!)
      end
    end
  end
end

class IssuesController

  include RedmineDrafts::IssuesControllerPatch

  prepend_before_action :set_draft, :only => [:new, :edit]

end

