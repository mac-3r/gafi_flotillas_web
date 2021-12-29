class TallerNuloCitas < ActiveRecord::Migration[6.0]
  def change
    change_column :maintenance_appointments, :catalog_workshop_id, :integer, null:true
  end
end
