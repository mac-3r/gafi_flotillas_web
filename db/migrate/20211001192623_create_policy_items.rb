class CreatePolicyItems < ActiveRecord::Migration[6.0]
  def change
    create_table :policy_items do |t|
      t.references :insurance_policy, null: false, foreign_key: true
      t.string :nombre
      t.string :clave
      t.text :descripcion
      t.boolean :estatus, default: true

      t.timestamps
    end
  end
end
