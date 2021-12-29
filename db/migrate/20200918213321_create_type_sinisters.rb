class CreateTypeSinisters < ActiveRecord::Migration[6.0]
  def change
    create_table :type_sinisters do |t|
      t.string :clave
      t.string :nombreSiniestro
      t.string :descripcion
      t.boolean :status

      t.timestamps
    end
  end
end
