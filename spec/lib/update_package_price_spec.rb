# frozen_string_literal: true

require "spec_helper"

RSpec.describe UpdatePackagePrice, type: :service do
  let!(:global_municipality) { create(:municipality, name: 'global') }
  let!(:package) { create(:package, name: 'Dunderhonung') }
  let!(:new_price_cents) { 200_00 }

  describe '.call' do
    context 'when updating the price' do
      it 'creates a new price record for the provided package' do
        expect {
          UpdatePackagePrice.call(package, new_price_cents)
        }.to change { package.prices.count }.by(1)

        expect(package.prices.last.amount_cents).to eq(new_price_cents)
      end
    end

    context 'when updating the price of one package' do
      let!(:other_package) { create(:package, name: 'business') }

      it 'does not affect other packages' do
        expect {
          UpdatePackagePrice.call(package, new_price_cents)
        }.not_to change { other_package.reload.prices.count }

        expect(other_package.reload.prices.count).to eq(0)
      end
    end

    context 'when updating price with a specific municipality' do
      let!(:stockholm) { create(:municipality, name: 'stockholm') }

      it 'creates a price record with the correct municipality' do
        UpdatePackagePrice.call(package, new_price_cents, municipality: 'stockholm')

        price = package.prices.last
        expect(price.municipality.name).to eq('stockholm')
        expect(price.amount_cents).to eq(new_price_cents)
      end
    end

    context 'when an invalid municipality is provided' do
      it 'creates a new municipality with the given name' do
        municipality_name = 'alien_island'

        expect {
          UpdatePackagePrice.call(package, new_price_cents, municipality: municipality_name)
        }.to change { Municipality.count }.by(1)

        municipality = Municipality.find_by(name: municipality_name)
        expect(municipality).to be_present
        expect(municipality.name).to eq(municipality_name)
      end
    end

    context 'when the price is negative' do
      it 'raises a validation error' do
        expect {
          UpdatePackagePrice.call(package, -100_00)
        }.to raise_error(ActiveRecord::RecordInvalid, "Validation failed: Amount cents must be greater than or equal to 0")
      end
    end

    context 'when no municipality is provided' do
      it 'assigns the price to the global municipality by default' do
        UpdatePackagePrice.call(package, new_price_cents)

        price = package.prices.last
        expect(price.municipality.name).to eq('global')
        expect(price.amount_cents).to eq(new_price_cents)
      end
    end

    context 'when multiple price updates are made' do
      it 'creates multiple price history entries' do
        UpdatePackagePrice.call(package, new_price_cents)
        second_price_cents = 250_00
        UpdatePackagePrice.call(package, second_price_cents)

        expect(package.prices.count).to eq(2)
        expect(package.prices.first.amount_cents).to eq(20_000)
        expect(package.prices.last.amount_cents).to eq(second_price_cents)
      end
    end
  end
end
