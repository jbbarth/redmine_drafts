require_dependency 'issues_controller'

class IssuesController
  prepend_before_filter :set_draft

  private

    def set_draft
      if params[:draft_id]
        draft = Draft.find params[:draft_id] rescue nil
        if draft
          params.merge!(draft.content)
        end
      end
    end
end

