json.array!(@levels) do |level|
  json.extract! level, :id, :value, :sufficiencies
  json.url level_url(level, format: :json)
end
