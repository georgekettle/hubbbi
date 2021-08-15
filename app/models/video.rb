class Video < ApplicationRecord
  VideoInfo.provider_api_keys = { youtube: ENV["YOUTUBE_API_TOKEN"], vimeo: ENV["VIMEO_API_TOKEN"] }
  VideoInfo.disable_providers = %w[Dailymotion Wistia]

  has_one :section_element, :as =>:element
  has_one :section, through: :section_element
  has_one :page, through: :section

  has_one_attached :file

  def info
    return nil unless url.present?
    video = VideoInfo.new(url)
  end
end
