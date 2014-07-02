json.array!(@pictures) do |picture|
  json.extract! picture, :id, :name, :height, :width, :url
  json.url picture_url(picture, format: :json)
end
