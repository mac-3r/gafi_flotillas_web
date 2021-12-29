class CreateAccountingImpacts < ActiveRecord::Migration[6.0]
  def change
    create_table :accounting_impacts do |t|
      t.references :catalog_branch, null: false, foreign_key: true
      t.string :nombre
      t.decimal :mantenimiento_equipo
      t.decimal :mantenimiento_maquinaria
      t.decimal :combustible
      t.decimal :plaqueo
      t.decimal :seguro
      t.decimal :permiso
      t.boolean :status

      t.timestamps
    end
  end
end
