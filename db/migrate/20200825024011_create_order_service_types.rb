class CreateOrderServiceTypes < ActiveRecord::Migration[6.0]
  def change
    create_table :order_service_types do |t|
      t.string :nombre
      t.string :descripcion
      t.string :origen
      t.boolean :status
      
      t.timestamps
    end
  end
end
