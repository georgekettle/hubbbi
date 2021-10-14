class Progression < ApplicationRecord
  belongs_to :progressable, polymorphic: true, touch: true
end
