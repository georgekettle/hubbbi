module Invitable
  extend ActiveSupport::Concern

  included do
    has_many :invites, -> { order(created_at: :desc) }, :as => :invitable, dependent: :destroy
  end
end
