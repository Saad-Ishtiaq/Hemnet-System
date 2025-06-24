class AddMunicipalityToPrices < ActiveRecord::Migration[7.1]
  def change
    add_reference :prices, :municipality, foreign_key: true, index: true
  end
end
