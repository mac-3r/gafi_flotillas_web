class CreateBudgets < ActiveRecord::Migration[6.0]
  def change
    create_table :budgets do |t|
      # t.references :catalog_branch, null: false, foreign_key: true
      # t.references :catalog_area, null: false, foreign_key: true
      # t.date :fecha_entrega
      # t.date :fecha_compra
      # t.string :clave
      # t.integer :status
      # t.text :motivo_rechazo
      # t.references :user, null: false, foreign_key: true
      t.integer :anio, default: 1
      t.integer :estatus
      t.timestamps
    end
  end
end
