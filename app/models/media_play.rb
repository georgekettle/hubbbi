class MediaPlay < ApplicationRecord
  belongs_to :group_member
  belongs_to :mediable, polymorphic: true
end
