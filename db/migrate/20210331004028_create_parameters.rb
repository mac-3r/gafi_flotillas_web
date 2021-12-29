class CreateParameters < ActiveRecord::Migration[6.0]
  def change
    create_table :parameters do |t|
      t.string :nombre
      t.text :valor
      t.text :valor_extendido

      t.timestamps
    end
  end
end
