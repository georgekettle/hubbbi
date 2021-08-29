class GroupMember < ApplicationRecord
  include Linkable

  belongs_to :user
  belongs_to :group
  has_many :course_members, dependent: :destroy
  has_many :courses, through: :course_members
  has_one :selected_user, class_name: 'User', :foreign_key => 'selected_group_member_id', dependent: :nullify

  enum role: { member: 1, editor: 2, admin: 3 }
  attribute :email, :string

  validates :user, uniqueness: { scope: :group, message: 'Is already a group member' }
  before_validation :set_user_id, if: :email?

  accepts_nested_attributes_for :user

  def set_user_id
    self.user = User.invite!(email: email)
  end

  def name
    user.full_name_or_email
  end
end
