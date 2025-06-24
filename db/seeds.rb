# frozen_string_literal: true

puts "Removing old packages and their price histories"
Package.destroy_all
Municipality.destroy_all

puts "Creating new packages"

packages_data = YAML.load_file(Rails.root.join("import/packages.yaml"))

amount_cents_data = packages_data.map { |package| { name: package['name'], amount_cents: package.delete('amount_cents') } }

Package.insert_all(packages_data)

global_municipality = Municipality.find_or_create_by!(name: 'global')

premium = Package.find_by!(name: "premium")
plus = Package.find_by!(name: "plus")
basic = Package.find_by!(name: "basic")

puts "Creating a price history for the packages"
prices = YAML.load_file(Rails.root.join("import/initial_price_history.yaml"))

def assign_global_municipality(prices)
  prices.map do |price|
    price['municipality'] ||= 'global'

    municipality = Municipality.find_or_create_by!(name: price['municipality'])
    price.merge(municipality_id: municipality.id)
  end
end

premium_prices = assign_global_municipality(prices["premium"])
plus_prices = assign_global_municipality(prices["plus"])
basic_prices = assign_global_municipality(prices["basic"])

premium.prices.insert_all(premium_prices.map { |price| price.except('municipality') })
plus.prices.insert_all(plus_prices.map { |price| price.except('municipality') })
basic.prices.insert_all(basic_prices.map { |price| price.except('municipality') })

puts "Creating final prices based on amount_cents_data"
amount_cents_data.each do |data|
  package = Package.find_by!(name: data[:name])

  municipality_id = global_municipality.id

  Price.create!(
    amount_cents: data[:amount_cents],
    package: package,
    municipality_id: municipality_id
  )
end
puts "Finished seeding the database with packages and prices"
