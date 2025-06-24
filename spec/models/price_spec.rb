# frozen_string_literal: true

require "spec_helper"

RSpec.describe Price, type: :model do
  let(:package) { create(:package, name: 'premium') }
  let(:municipality) { create(:municipality, name: 'stockholm') }
  let(:global_municipality) { create(:municipality, name: 'global') }

  describe 'validations' do
    it 'validates presence of amount_cents' do
      price = Price.new(amount_cents: nil, package: package, municipality: municipality)
      expect(price.valid?).to eq(false)
      expect(price.errors[:amount_cents]).to include("can't be blank")
    end
  end

  describe 'associations' do
    it 'belongs to a package' do
      price = Price.new(amount_cents: 100_00, package: package, municipality: municipality)
      expect(price.package).to eq(package)
    end

    it 'belongs to a municipality' do
      price = Price.new(amount_cents: 100_00, package: package, municipality: municipality)
      expect(price.municipality).to eq(municipality)
    end

    context 'when package is nil' do
      it 'is not valid without a package' do
        price = Price.new(amount_cents: 100_00, municipality: municipality)
        expect(price.valid?).to eq(false)
        expect(price.errors[:package]).to include("must exist")
      end
    end
  end

  describe 'price logic' do
    context 'when amount_cents is negative' do
      it 'does not save the price' do
        price = Price.new(amount_cents: -50_00, package: package, municipality: municipality)
        expect(price.save).to eq(false)
      end
    end

    context 'when amount_cents is valid' do
      it 'saves the price successfully' do
        price = Price.new(amount_cents: 500_00, package: package, municipality: municipality)
        expect(price.save).to eq(true)
      end
    end
  end

  describe 'callbacks' do
    it 'creates a price with the global municipality if none is provided' do
      price = Price.create(amount_cents: 200_00, package: package)
      expect(price.municipality.name).to eq('global')
    end
  end
end
