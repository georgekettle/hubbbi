class GroupMember < ApplicationRecord
  belongs_to :user
  belongs_to :group
  has_many :group_member_permissions, dependent: :destroy
  has_many :permissions, through: :group_member_permissions
  has_many :links, as: :linkable, dependent: :destroy

  enum role: { member: 1, editor: 2, admin: 3 }
  attribute :email, :string

  validates :user, uniqueness: { scope: :group, message: 'Looks like this email is already a group member' }
  before_validation :set_user_id, if: :email?

  def set_user_id
    self.user = User.invite!(email: email)
  end
end
