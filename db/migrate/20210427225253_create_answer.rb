class CreateAnswer < ActiveRecord::Migration[6.0]
  def change
    create_table :answers do |t|
      t.string :descripcion
      t.integer :estatus, :default => true
      
      t.timestamps
    end
  end
end
