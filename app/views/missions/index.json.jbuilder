json.array!(@missions) do |mission|
  json.extract! mission, :id, :description, :category_id, :level_id
  json.url mission_url(mission, format: :json)
end
