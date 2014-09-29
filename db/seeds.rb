# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

require 'csv'

# seedを投入するCSVファイルのリスト
csv_names = %w(roles levels categories seminars missions acquisitions users)

csv_names.each do |csv_name|
  path = Rails.root.join("db/seeds", Rails.env, csv_name + ".csv")

  if File.exist?(path)
    puts "Creating #{csv_name}..."

    # require path

    # WindowsのMicrosoft Excelの出力したCSVファイルを想定
    CSV.foreach(path, { encoding: "cp932:utf-8", row_sep: "\r\n", headers: true }) do |row|
      (csv_name.classify.constantize).new(row.to_hash).save
    end
  end
end

# seedを投入するプログラムファイルのリスト
program_names = %w()
program_names.each do |program_name|
  path = Rails.root.join("db/seeds", Rails.env, program_name + ".rb")

  if File.exist?(path)
    puts "Creating #{program_name}..."

    require path
  end
end
