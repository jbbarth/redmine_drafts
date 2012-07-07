class Draft < ActiveRecord::Base
  belongs_to :user
  belongs_to :element, :polymorphic => true

  serialize :content

  def content
    read_attribute(:content) || Hash.new
  end

  def self.find_for_issue(conditions)
    where(conditions.merge(:element_type => "Issue")).last
  end

  def self.find_or_create_for_issue(conditions)
    find_for_issue(conditions) || create(conditions.merge(:element_type => "Issue"))
  end
end
