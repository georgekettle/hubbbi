module Mediable
  extend ActiveSupport::Concern

  included do
    has_many :media_plays, :as => :mediable, dependent: :destroy
  end
end
