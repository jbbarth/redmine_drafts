class Draft < ActiveRecord::Base
  include Redmine::SafeAttributes

  belongs_to :user
  belongs_to :element, :polymorphic => true

  serialize :content

  safe_attributes "user_id", "element_id", "element_type"

  scope :old_drafts, -> {where('updated_at < ?', 2.years.ago)}

  def content
    hsh = read_attribute(:content) || Hash.new
    if hsh.present? && hsh.respond_to?(:to_hash)
      #Redmine 2.1.x had hsh[:notes] while Redmine 2.2.x moved it to
      #hsh[:issue][:notes] when introducing private notes. We want to
      #support both formats so we need to save and restore at both places.
      hsh["issue"] ||= {}
      hsh["notes"] = hsh["issue"]["notes"] if hsh["notes"].blank?
      hsh["issue"]["notes"] = hsh["notes"] if hsh["issue"]["notes"].blank?
    end
    hsh
  end

  def self.find_for_issue(conditions)
    where(conditions.merge(:element_type => "Issue")).last
  end

  def self.find_or_create_for_issue(conditions)
    find_for_issue(conditions) || create(conditions.merge(:element_type => "Issue"))
  end

  def self.purge_older_drafts!
    old_drafts.delete_all
  end
end
