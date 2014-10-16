require 'csv'

csv_name = "missions"

path = Rails.root.join("db/seeds", Rails.env, csv_name + ".csv")

if File.exist?(path)
  puts "Creating #{csv_name}..."

  @categories = Category.all

  # WindowsのMicrosoft Excelの出力したCSVファイルを想定
  CSV.foreach(path, { encoding: "cp932:utf-8", row_sep: "\r\n", headers: true }) do |row|
    hash = row.to_hash
    acquisitions = []
    @categories.each do |category|
      acquisition = Acquisition.new(category_id: category.id, experience: hash[category.name])
      hash.delete(category.name)
      acquisitions << acquisition
    end
    mission = Mission.create(hash)
    acquisitions.each do |acquisition|
      acquisition.mission_id = mission.id
      acquisition.save
    end
  end
end
