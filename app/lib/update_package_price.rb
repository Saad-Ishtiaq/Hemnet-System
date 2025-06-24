# frozen_string_literal: true

class UpdatePackagePrice
  def self.call(package, new_price_cents, **options)
    Package.transaction do
      municipality_name = options[:municipality] || 'global'
      municipality = Municipality.find_or_create_by!(name: municipality_name)

      Price.create!(
        package: package,
        amount_cents: new_price_cents,
        municipality_id: municipality.id
      )
    end
  end
end
