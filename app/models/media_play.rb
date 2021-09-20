class MediaPlay < ApplicationRecord
  belongs_to :group_member
  has_one :user, through: :group_member
  belongs_to :mediable, polymorphic: true

  acts_as_list scope: :group_member
end
