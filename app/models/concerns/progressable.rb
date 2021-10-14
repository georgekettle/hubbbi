module Progressable
  extend ActiveSupport::Concern

  included do
    has_one :progression, :as => :progressable
  end
end
