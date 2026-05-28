module RedmineDrafts::IssuesControllerPatch
  def set_draft
    if params[:draft_id].present?
      draft = User.current.drafts.find_by(id: params[:draft_id])
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

