json.array!(@uploads) do |upload|
  json.extract! upload, :filename, :attachment
  json.url upload_url(upload, format: :json)
end
