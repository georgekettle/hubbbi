class GroupMember < ApplicationRecord
  include Linkable

  belongs_to :user
  belongs_to :group

  enum role: { member: 1, editor: 2, admin: 3 }
  attribute :email, :string

  validates :user, uniqueness: { scope: :group, message: 'Is already a group member' }
  before_validation :set_user_id, if: :email?

  def set_user_id
    self.user = User.invite!(email: email)
  end
end
