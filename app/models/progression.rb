class Progression < ApplicationRecord
  belongs_to :progressable, polymorphic: true, touch: true
  belongs_to :group_member
end
