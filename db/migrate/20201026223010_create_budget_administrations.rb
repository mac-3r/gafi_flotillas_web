class CreateBudgetAdministrations < ActiveRecord::Migration[6.0]
  def change
    create_table :budget_administrations do |t|
      t.string :clave
      t.references :catalog_branch, null: false, foreign_key: true
      t.date :fecha_entrega
      t.references :catalog_area, null: false, foreign_key: true
      t.date :fecha_compra

      t.timestamps
    end
  end
end
