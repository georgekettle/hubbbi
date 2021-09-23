class GroupMember < ApplicationRecord
  include Linkable

  enum role: %i{member editor admin}

  belongs_to :user
  belongs_to :group
  has_many :course_members, dependent: :destroy
  has_many :courses, through: :course_members
  has_one :selected_user, class_name: 'User', :foreign_key => 'selected_group_member_id', dependent: :nullify
  has_many :media_plays, -> { order(:position) }, dependent: :destroy

  validates :user, uniqueness: { scope: :group, message: 'is already a group member' }
  validates :role, presence: true

  accepts_nested_attributes_for :user

  def name
    user.full_name_or_email
  end

  def current_media_plays
    media_plays.where(complete: false)
  end
end
