module SubInvitable
  extend ActiveSupport::Concern

  included do
    has_many :sub_invites, :as => :invitable, dependent: :destroy
  end
end
