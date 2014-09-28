# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

require 'csv'

# seedを投入するテーブルのリスト
table_names = %w(roles levels categories missions acquisitions)

table_names.each do |table_name|
  path = Rails.root.join("db/seeds", Rails.env, table_name + ".csv")

  if File.exist?(path)
    puts "Creating #{table_name}..."

    # WindowsのMicrosoft Excelの出力したCSVファイルを想定
    CSV.foreach(path, { encoding: "cp932:utf-8", row_sep: "\r\n", headers: true }) do |row|
      (table_name.classify.constantize).new(row.to_hash).save
    end
  end
end
