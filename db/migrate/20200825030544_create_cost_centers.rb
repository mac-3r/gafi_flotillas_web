class CreateCostCenters < ActiveRecord::Migration[6.0]
  def change
    create_table :cost_centers do |t|
      t.string :clave
      t.string :descripcion
      t.boolean :status
      
      t.timestamps
    end
  end
end
