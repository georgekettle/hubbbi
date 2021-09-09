class SubInvite < ApplicationRecord
  belongs_to :invite
  belongs_to :invitable, polymorphic: true
end
