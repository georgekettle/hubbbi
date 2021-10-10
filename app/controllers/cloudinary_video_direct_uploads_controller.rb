# frozen_string_literal: true

# ActiveStorage fix to support direct uploads with a custom per-model service
# When https://github.com/rails/rails/pull/38957 gets released in a future version, we
# should remove this fix.
class CoudinaryVideoDirectUploadsController < ActiveStorage::DirectUploadsController
  private

  def blob_args
    super.merge(service_name: :cloudinary_video)
  end
end
