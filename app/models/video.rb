class Video < ApplicationRecord
  has_one :section_element, :as =>:element
  has_one :section, through: :section_element
  has_one :page, through: :section

  has_one_attached :file

  def info
    return nil unless url.present?
    video = VideoInfo.new(url)
    # set_thumbnails(video) if video.provider == "YouTube"
    # video
  end

  private

  # def set_thumbnails(video)
  #   video.thumbnail_large = "https://i.ytimg.com/vi/#{video.video_id}/maxresdefault.jpg"
  # end
end
