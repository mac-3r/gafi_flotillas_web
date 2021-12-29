class AddUsersToFrequencies < ActiveRecord::Migration[6.0]
  def change
    add_reference :frequency_concepts, :user
    add_column :frequency_concepts, :usuario_desactiva_id, :integer
    add_reference :concepts, :user
    add_column :concepts, :usuario_desactiva_id, :integer
    add_reference :concept_descriptions, :user
    add_column :concept_descriptions, :usuario_desactiva_id, :integer
    add_reference :concept_brands, :user
    add_column :concept_brands, :usuario_desactiva_id, :integer
  end
end
