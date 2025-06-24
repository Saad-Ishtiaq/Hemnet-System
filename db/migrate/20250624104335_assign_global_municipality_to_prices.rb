class AssignGlobalMunicipalityToPrices < ActiveRecord::Migration[7.1]
  def up
    global_municipality = Municipality.find_or_create_by!(name: 'global')

    Price.where(municipality_id: nil).update_all(municipality_id: global_municipality.id)
  end

  def down
    global_municipality = Municipality.find_by(name: 'global')
    
    if global_municipality
      Price.where(municipality_id: global_municipality.id).update_all(municipality_id: nil)
    end
  end
end
