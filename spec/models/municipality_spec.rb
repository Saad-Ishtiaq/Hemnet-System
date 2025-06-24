# frozen_string_literal: true

require "spec_helper"

RSpec.describe Municipality, type: :model do
  let!(:global_municipality) { create(:municipality, name: 'global') }

  describe 'associations' do
    it 'has many prices' do
      expect(Municipality.reflect_on_association(:prices).macro).to eq(:has_many)
    end

    it 'destroys associated prices when destroyed' do
      municipality = create(:municipality)
      price = create(:price, municipality: municipality)

      expect { municipality.destroy }.to change { Price.count }.by(-1)
    end
  end

  describe 'validations' do
    context 'when valid' do
      it 'is valid with a name' do
        municipality = build(:municipality, name: 'stockholm')
        expect(municipality).to be_valid
      end
    end

    context 'when invalid' do
      it 'is invalid without a name' do
        municipality = build(:municipality, name: nil)
        expect(municipality).not_to be_valid
        expect(municipality.errors[:name]).to include("can't be blank")
      end

      it 'is invalid with a duplicate name' do
        create(:municipality, name: 'stockholm')
        municipality = build(:municipality, name: 'stockholm')

        expect(municipality).not_to be_valid
        expect(municipality.errors[:name]).to include("has already been taken")
      end
    end
  end

  describe 'edge cases' do
    it 'does not create a municipality with a blank name' do
      municipality = build(:municipality, name: ' ')
      expect(municipality).not_to be_valid
      expect(municipality.errors[:name]).to include("can't be blank")
    end
  end
end
