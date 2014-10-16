json.array!(@acquisitions) do |acquisition|
  json.extract! acquisition, :id, :mission_id, :category_id, :experience
  json.url acquisition_url(acquisition, format: :json)
end
