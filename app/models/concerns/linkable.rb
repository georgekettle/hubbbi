module Linkable
  extend ActiveSupport::Concern

  included do
    has_many :links, :as => :linkable, dependent: :destroy
  end
end
