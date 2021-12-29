class CreateConcepts < ActiveRecord::Migration[6.0]
  def change
    create_table :concepts do |t|
      t.string :descripcion

      t.timestamps
    end
  end
end
