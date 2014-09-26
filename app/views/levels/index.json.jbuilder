json.array!(@levels) do |level|
  json.extract! level, :id, :value, :sufficiency
  json.url level_url(level, format: :json)
end
