class GroupMember < ApplicationRecord
  include Linkable

  belongs_to :user
  belongs_to :group
  has_many :course_members, dependent: :destroy
  has_many :courses, through: :course_members
  has_one :selected_user, class_name: 'User', :foreign_key => 'selected_group_member_id', dependent: :nullify

  enum role: { member: 1, editor: 2, admin: 3 }
  attribute :email, :string

  validates :user, uniqueness: { scope: :group, message: 'is already a group member' }

  accepts_nested_attributes_for :user

  def name
    user.full_name_or_email
  end
end
