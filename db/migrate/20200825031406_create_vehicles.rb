class CreateVehicles < ActiveRecord::Migration[6.0]
  def change
    create_table :vehicles do |t|
      t.string :clave
      t.integer :numero_economico
      t.references :catalog_company, null: false, foreign_key: true
      t.references :branch_office, null: false, foreign_key: true
      t.references :cost_center, null: false, foreign_key: true
      t.references :responsable, null: false, foreign_key: true
      t.references :vehicle_status, null: false, foreign_key: true
      t.references :vehicle_type, null: false, foreign_key: true
      t.references :vehicle_brand, null: false, foreign_key: true
      #t.references :vehicle_model, null: false, foreign_key: true
      t.string :numero_serie
      t.string :numero_motor
      t.string :transmision
      t.references :billed_company, null: false, foreign_key: true
      t.string :numero_factura
      t.date :fecha_compra
      t.decimal :valor_compra
      t.string :numero_factura_adapt
      t.string :numero_serie_adapt
      t.decimal :valor_adapt
      t.references :catalog_route, null: false, foreign_key: true
      t.string :numero_poliza
      t.string :inciso
      t.references :policy_coverage, null: false, foreign_key: true
      t.references :insurance_beneficiary, null: false, foreign_key: true
      t.string :numero_placa
      t.references :plate_state, null: false, foreign_key: true
      t.string :permiso_federal_carga
      t.string :permiso_fisico_mecanico
      t.string :permiso_ambiental
      t.decimal :litros_autorizados
      t.boolean :status

      t.timestamps
    end
  end
end
