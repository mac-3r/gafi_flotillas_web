class AddClavesToConcepts < ActiveRecord::Migration[6.0]
  def change
    add_column :concepts, :clave, :string
    add_column :concept_descriptions, :clave, :string
    add_column :concepts, :estatus, :boolean, default: true
    add_column :concept_descriptions, :estatus, :boolean, default: true
    remove_column :concept_descriptions, :concept_id
  end
end
