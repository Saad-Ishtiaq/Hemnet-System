# frozen_string_literal: true

class UpdatePackagePrice
  def self.call(package, new_price_cents, **options)
    Package.transaction do
      # Add a pricing history record
      Price.create!(package: package, amount_cents: package.amount_cents)

      # Update the current price
      package.update!(amount_cents: new_price_cents)
    end
  end
end
