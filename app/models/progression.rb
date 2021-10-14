class Progression < ApplicationRecord
  belongs_to :progressable, polymorphic: true, touch: true
  belongs_to :group_member

  def complete?
    current == total
  end
end
