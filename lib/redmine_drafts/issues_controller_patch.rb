require_dependency 'issues_controller'

module RedmineDrafts::IssuesControllerPatch
  def set_draft
    if params[:draft_id].present?
      draft = Draft.find(params[:draft_id]) rescue nil
      if draft.present?
        @draft_attachments = prepare_draft_attachments(draft.content["attachments"].permit!.to_h)
        params.merge!(draft.content.reject{|k,v| k == "attachments"}.permit!)
      end
    end
  end

  private

  def prepare_draft_attachments(draft_params)
    return [] unless draft_params.present?

    attachments = draft_params.map do |_, param|
      token = param['token']
      attachment_id = token.split('.').first
      attachment = Attachment.find_by(id: attachment_id)

      next nil unless attachment

      {
        filename: attachment.filename,
        description: attachment.description,
        token: token,
        path: attachment_path(attachment, format: 'js')
      }
    end

    @failed_draft_attachments_count = attachments.count(nil)
    attachments.compact
  end
end

class IssuesController

  include RedmineDrafts::IssuesControllerPatch

  prepend_before_action :set_draft, :only => [:new, :edit]

end
