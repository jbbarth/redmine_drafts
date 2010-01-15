require_dependency 'issue'

class Issue
  has_many :drafts, :as => :element

  after_create :clean_drafts_after_create
  after_update :clean_drafts_after_update
  
  def clean_drafts_after_create
    draft = Draft.find_for_issue(:element_id => 0, :user_id => User.current.id)
    draft.destroy if draft
  end
  
  def clean_drafts_after_update
    self.drafts.select{|d| d.user_id == User.current.id}.each(&:destroy)
  end
end
