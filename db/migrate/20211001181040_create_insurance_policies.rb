class CreateInsurancePolicies < ActiveRecord::Migration[6.0]
  def change
    create_table :insurance_policies do |t|
      t.references :catalog_vendor, null: false, foreign_key: true
      t.references :policy_coverage, null: false, foreign_key: true
      t.string :clave_aseguradora
      t.date :fecha_inicio
      t.date :fecha_fin
      t.boolean :estatus, default: true

      t.timestamps
    end
  end
end
