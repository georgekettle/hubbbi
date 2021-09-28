class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :group_members, dependent: :destroy
  has_many :groups, through: :group_members

  belongs_to :selected_group_member, class_name: 'GroupMember', :foreign_key => 'selected_group_member_id', optional: true
  has_one :selected_group, through: :selected_group_member, :source => :group

  has_many :invitations, :class_name => "Invite", :foreign_key => 'recipient_id'
  has_many :sent_invites, :class_name => "Invite", :foreign_key => 'sender_id'

  def full_name_or_email
    full_name.present? ? full_name.downcase.titleize : email.downcase
  end
end
