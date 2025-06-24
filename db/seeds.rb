# frozen_string_literal: true

puts "Removing old packages and their price histories"
Package.destroy_all

puts "Creating new packages"

Package.insert_all(
  YAML.load_file(Rails.root.join("import/packages.yaml"))
)

premium = Package.find_by!(name: "premium")
plus = Package.find_by!(name: "plus")
basic = Package.find_by!(name: "basic")

puts "Creating a price history for the packages"
prices = YAML.load_file(Rails.root.join("import/initial_price_history.yaml"))

premium.prices.insert_all(prices["premium"])
plus.prices.insert_all(prices["plus"])
basic.prices.insert_all(prices["basic"])
