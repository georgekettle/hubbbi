class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :group_members, dependent: :destroy
  has_many :groups, through: :group_members

  validates :full_name, presence: true

  def full_name
    super ? super.downcase.titleize : super
  end
end
