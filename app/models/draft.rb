class Draft < ActiveRecord::Base
  belongs_to :user
  belongs_to :element, :polymorphic => true

  def content
    YAML.load(read_attribute(:content))
  end

  def self.find_for_issue(issue, user, version)
    unless issue.new_record? || user.anonymous?
      find(:last, :conditions => {
                      :user_id => user.id,
                      :element_type => "Issue",
                      :element_id => issue.id,
                      :element_lock_version => version
      })
    end
  end
end
