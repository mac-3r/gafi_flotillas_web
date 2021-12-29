class CreateConceptConceptdescriptions < ActiveRecord::Migration[6.0]
  def change
    create_table :concept_conceptdescriptions do |t|
      t.references :concept, null: false, foreign_key: true
      t.references :concept_description, null: false, foreign_key: true

      t.timestamps
    end
  end
end
