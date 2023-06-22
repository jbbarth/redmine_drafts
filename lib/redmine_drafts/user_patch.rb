require_dependency 'principal'
require_dependency 'user'

class User < Principal
  has_many :drafts, :dependent => :destroy
end