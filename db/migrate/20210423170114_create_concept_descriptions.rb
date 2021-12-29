class CreateConceptDescriptions < ActiveRecord::Migration[6.0]
  def change
    create_table :concept_descriptions do |t|
      t.string :nombre
      t.integer :tipo_afinacion
      t.references :concept, null: false, foreign_key: true

      t.timestamps
    end
  end
end
