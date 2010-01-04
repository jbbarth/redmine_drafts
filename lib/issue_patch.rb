require_dependency 'issue'

class Issue
  has_many :drafts, :as => :element
end
