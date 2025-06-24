# frozen_string_literal: true

class PriceHistoryService
  def initialize(year:, package:, municipality: nil)
    @year = year
    @package = package
    @municipality = municipality
  end

  def call
    cache_key = generate_cache_key

    cached_data = Rails.cache.read(cache_key)
    return cached_data if cached_data

    Rails.cache.fetch(cache_key, expires_in: 1.hour) do
      query = build_price_query
      group_prices_by_municipality(query)
    end
  end

  private

  def generate_cache_key
    "price_history/#{@year}/#{@package.downcase}/#{@municipality&.downcase || 'all'}"
  end

  def build_price_query
    query = Price.by_year_and_package(@year, @package)
    query = query.by_municipality(@municipality) if @municipality
    query
  end

  def group_prices_by_municipality(query)
    query.group_by { |price| price.municipality.name }
         .transform_values { |prices| prices.map(&:amount_cents) }
  end
end
