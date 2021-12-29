class CreateResponsables < ActiveRecord::Migration[6.0]
  def change
    create_table :responsables do |t|
      t.string :nombre
      t.boolean :status

      t.timestamps
    end
  end
end
