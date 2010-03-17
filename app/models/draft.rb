class Draft < ActiveRecord::Base
  belongs_to :user
  belongs_to :element, :polymorphic => true

  def content
    c = read_attribute(:content)
    c.nil? ? {} : YAML.load(c)
  end

  def self.find_for_issue(conditions)
    find :last, :conditions => conditions.merge(:element_type => "Issue")
  end

  def self.find_or_create_for_issue(conditions)
    find_for_issue(conditions) || create(conditions.merge(:element_type => "Issue"))
  end
end
