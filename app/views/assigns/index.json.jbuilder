json.array!(@assigns) do |assign|
  json.extract! assign, :id, :user_id, :mission_id
  json.url assign_url(assign, format: :json)
end
