module AssetHelper
  def transform_extension(url, extension)
    url.gsub(/\.(png|jpeg|jpg|pdf|mp3|mp4)$/, extension)
  end
end
