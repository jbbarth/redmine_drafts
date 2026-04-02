# frozen_string_literal: true

module RedmineDrafts::UserPatch
end

class User < Principal
  has_many :drafts, dependent: :destroy
end
