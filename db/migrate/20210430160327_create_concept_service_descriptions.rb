class CreateConceptServiceDescriptions < ActiveRecord::Migration[6.0]
  def change
    create_table :concept_service_descriptions do |t|
      t.references :concept_description, null: false, foreign_key: true
      t.references :concept_service, null: false, foreign_key: true

      t.timestamps
    end
  end
end
