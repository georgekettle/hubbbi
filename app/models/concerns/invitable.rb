module Invitable
  extend ActiveSupport::Concern

  included do
    has_many :invites, :as => :invitable, dependent: :destroy
  end
end
