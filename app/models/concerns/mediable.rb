module Mediable
  extend ActiveSupport::Concern

  included do
    has_many :media_playss, :as => :mediable
  end
end
