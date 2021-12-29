class CreateConceptServices < ActiveRecord::Migration[6.0]
  def change
    add_column :frequency_concepts, :mes_inicial, :integer
    create_table :concept_services do |t|
      t.string :descripcion
      t.integer :estatus

      t.timestamps
    end
  end
end
