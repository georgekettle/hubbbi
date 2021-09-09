class Invite < ApplicationRecord
  belongs_to :invitable, polymorphic: true
  belongs_to :sender, class_name: "User"
  belongs_to :recipient, class_name: "User", optional: true

  validates :email, presence: true
  validates :invitable, presence: true
  validates :sender, presence: true
end
