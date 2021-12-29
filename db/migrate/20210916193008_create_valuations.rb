class CreateValuations < ActiveRecord::Migration[6.0]
  def change
    create_table :valuations do |t|
      t.string :tipo_zona
      t.string :descripcion
      t.float :valor
      t.boolean :estatus, default: true

      t.timestamps
    end
  end
end
