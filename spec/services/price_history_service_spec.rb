require 'spec_helper'

RSpec.describe PriceHistoryService, type: :service do
  let!(:package) { create(:package, name: 'premium') }
  let!(:municipality) { create(:municipality, name: 'stockhom') }
  let!(:price) { create(:price, package: package, municipality: municipality, amount_cents: 66600, created_at: '2025-03-01') }

  describe '#call' do
    context 'when only package and year are provided' do
      it 'fetches the result from the database and stores it in cache without municipality' do
        cache_key = "price_history/2025/premium/all"
        service = PriceHistoryService.new(year: 2025, package: 'premium')

        result = service.call

        expect(Rails.cache.read(cache_key)).to eq({"stockhom" => [66600]})
        
        expect(result).to eq({"stockhom" => [66600]})
      end
    end

    context 'when cache miss' do
      it 'queries the database and stores the result in cache' do
        cache_key = "price_history/2025/premium/stockhom"
        expect(Rails.cache.read(cache_key)).to be_nil
        service = PriceHistoryService.new(year: 2025, package: 'premium', municipality: 'stockhom')
        
        result = service.call

        expect(result).to eq({"stockhom" => [66600]})

        expect(Rails.cache.read(cache_key)).to eq({"stockhom" => [66600]})
      end
    end

    context 'when cache hit' do
      it 'fetches the result from the cache' do
        cache_key = "price_history/2025/premium/stockhom"

        service = PriceHistoryService.new(year: 2025, package: 'premium', municipality: 'stockhom')

        service.call

        expect(Rails.cache.read(cache_key)).to eq({"stockhom" => [66600]})
      end
    end

    context 'when no data found' do
      it 'returns an empty hash' do
        service = PriceHistoryService.new(year: 2025, package: 'premium', municipality: 'non_existent_municipality')
        result = service.call
        expect(result).to eq({})
      end
    end
  end
end
