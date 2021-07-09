class ContentPermission < ApplicationRecord
  belongs_to :permission
  belongs_to :content
end
