class AddNotNullConstraintToMunicipalityIdInPrices < ActiveRecord::Migration[7.1]
  def change
    change_column_null :prices, :municipality_id, false
  end
end
