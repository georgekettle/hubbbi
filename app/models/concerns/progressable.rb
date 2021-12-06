module Progressable
  extend ActiveSupport::Concern

  included do
    has_many :progressions, :as => :progressable, dependent: :destroy
  end
end
