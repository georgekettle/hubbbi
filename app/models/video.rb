class Video < ApplicationRecord
  VideoInfo.provider_api_keys = { youtube: ENV["YOUTUBE_API_TOKEN"], vimeo: ENV["VIMEO_API_TOKEN"] }
  VideoInfo.disable_providers = %w[Dailymotion Wistia]

  has_one :section_element, :as =>:element
  has_one :section, through: :section_element
  has_one :page, through: :section

  has_one_attached :file, :service => :cloudinary_video

  # tags
  acts_as_taggable_on :tags

  def info
    return nil unless url.present?
    video = VideoInfo.new(url)
  rescue
    return nil
  end

  def image_preview_url
    return if file.blank?

    file.url.split(".")[0..-2].push("jpg")&.join(".")
  end

  def vimeo_hash
    # necessary to display private videos
    return nil unless url.present?
    url.split('/').last
  end
end
