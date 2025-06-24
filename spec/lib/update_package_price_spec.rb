# frozen_string_literal: true

require "spec_helper"

RSpec.describe UpdatePackagePrice do
  it "updates the current price of the provided package" do
    package = Package.create!(name: "Dunderhonung")

    UpdatePackagePrice.call(package, 200_00)
    expect(package.reload.amount_cents).to eq(200_00)
  end

  it "only updates the passed package price" do
    package = Package.create!(name: "Dunderhonung")
    other_package = Package.create!(name: "Farmors köttbullar", amount_cents: 100_00)

    expect {
      UpdatePackagePrice.call(package, 200_00)
    }.not_to change {
      other_package.reload.amount_cents
    }
  end

  it "stores the old price of the provided package in its price history" do
    package = Package.create!(name: "Dunderhonung", amount_cents: 100_00)

    UpdatePackagePrice.call(package, 200_00)
    expect(package.prices).to be_one
    price = package.prices.first
    expect(price.amount_cents).to eq(100_00)
  end
end
