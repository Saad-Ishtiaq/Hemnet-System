# frozen_string_literal: true

require "spec_helper"

RSpec.describe Package, type: :model do
  let!(:global_municipality) { create(:municipality, name: 'global') }
  let!(:premium_package) { create(:package, name: 'premium') }
  let!(:plus_package) { create(:package, name: 'plus') }

  describe 'validations' do
    it 'is valid with a name' do
      package = build(:package, name: 'platinum')
      expect(package).to be_valid
    end

    it 'is invalid without a name' do
      package = build(:package, name: nil)
      expect(package).not_to be_valid
      expect(package.errors[:name]).to include("can't be blank")
    end

    it 'is invalid with a duplicate name' do
      package = build(:package, name: 'premium')
      expect(package).not_to be_valid
      expect(package.errors[:name]).to include("has already been taken")
    end
  end

  describe 'associations' do
    it 'has many prices' do
      expect(Package.reflect_on_association(:prices).macro).to eq(:has_many)
    end
  end

  describe 'callbacks' do
    context 'when creating a price without a municipality' do
      it 'assigns the global municipality to the price' do
        price = premium_package.prices.create!(amount_cents: 100)

        expect(price.municipality).to eq(global_municipality)
      end
    end

    context 'when creating a price with a specific municipality' do
      let!(:new_municipality) { create(:municipality, name: 'gothenburg') }

      it 'assigns the provided municipality to the price' do
        price = premium_package.prices.create!(amount_cents: 100, municipality_id: new_municipality.id)

        expect(price.municipality).to eq(new_municipality)
      end
    end
  end

  describe 'creating price records' do
    it 'creates a price record with valid amount_cents and municipality_id' do
      price_data = { amount_cents: 100, municipality_id: global_municipality.id }
      price = premium_package.prices.create!(price_data)

      expect(price.amount_cents).to eq(100)
      expect(price.municipality_id).to eq(global_municipality.id)
      expect(price.package).to eq(premium_package)
    end

    it 'creates a price record for the package with the global municipality if municipality is nil' do
      price = premium_package.prices.create!(amount_cents: 100, municipality_id: nil)

      expect(price.municipality_id).to eq(global_municipality.id)
      expect(price.package).to eq(premium_package)
    end
  end
end
