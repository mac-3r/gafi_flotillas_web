class AddColumnsLicences < ActiveRecord::Migration[6.0]
  def change
    add_column :catalog_licences, :numero_licencia, :varchar
    add_column :catalog_licences, :fecha_vencimiento, :date
    add_reference :catalog_licences, :vehicle, foreign_key: true
  end
end
