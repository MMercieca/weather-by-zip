# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
# Zipcode.create!(zip: '49503', lat: 42.962778, long: -85.667778, locality: 'Grand Rapids, MI')
# Zipcode.create!(zip: '95015', lat: 37.3200, long: -122.0300, locality: 'Cupertino, CA')
# Zipcode.create!(zip: '95014', lat: 37.3132, long: -122.0724, locality: 'Cupertino, CA')
require 'csv'

CSV.foreach(Rails.root.join('vendor', 'uszips.csv'), :headers => true) do |row|
  Zipcode.create!(zip: row['zip'], lat: row['lat'], long: row['lng'], locality: row['county_name'])
end