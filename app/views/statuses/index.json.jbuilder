json.array!(@statuses) do |status|
  json.extract! status, :id, :user_id, :category_id, :experience
  json.url status_url(status, format: :json)
end
