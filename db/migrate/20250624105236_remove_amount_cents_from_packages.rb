class RemoveAmountCentsFromPackages < ActiveRecord::Migration[7.1]
  def up
    Package.find_each do |package|
      amount_cents = package.amount_cents

      global_municipality = Municipality.find_or_create_by!(name: 'global')

      Price.create!(
        amount_cents: amount_cents,
        package: package,
        municipality_id: global_municipality.id
      )
    end

    remove_column :packages, :amount_cents, :integer
  end

  def down
    add_column :packages, :amount_cents, :integer, null: false, default: 0

    Package.find_each do |package|
      last_price = package.prices.order(created_at: :desc).first
      if last_price
        package.update!(amount_cents: last_price.amount_cents)
      else
        package.update!(amount_cents: 0)
      end
    end
  end
end
