class Draft < ActiveRecord::Base
  belongs_to :user
  belongs_to :element, :polymorphic => true

  def self.find_for_issue(issue, user)
    unless issue.new_record? || user.anonymous?
      find(:last, :conditions => {:user_id => user.id, :element_type => "Issue", :element_id => issue.id})
    end
  end
end
