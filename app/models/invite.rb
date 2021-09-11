class Invite < ApplicationRecord
  belongs_to :invitable, polymorphic: true
  belongs_to :sender, class_name: "User"
  belongs_to :recipient, class_name: "User", optional: true
  has_many :sub_invites, dependent: :destroy

  enum status: [:pending, :accepted , :declined]

  validates :email, presence: true
  validates :invitable, presence: true
  validates :sender, presence: true

  before_create :generate_token
  before_save :check_user_existence

  accepts_nested_attributes_for :sub_invites

  def generate_token
     self.token = Digest::SHA1.hexdigest([self.invitable_id, Time.now, rand].join)
  end


  def check_user_existence
    recipient = User.find_by_email(email)
    if recipient
      self.recipient = recipient
    end
  end
end
