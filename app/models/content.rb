class Content < ApplicationRecord
  enum status: { draft: 1, published: 2 }
end
