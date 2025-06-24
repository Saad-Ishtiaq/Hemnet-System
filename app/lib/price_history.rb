# frozen_string_literal: true

class PriceHistory
  def self.call(year:, package:, municipality: nil)
    validate_arguments(year, package)

    service = PriceHistoryService.new(year: year, package: package, municipality: municipality)
    service.call
  end

  private

  def self.validate_arguments(year, package)
    raise ArgumentError, "Year must be an integer" unless year.is_a?(Integer)
    raise ArgumentError, "Package must be a string" unless package.is_a?(String)
  end
end
