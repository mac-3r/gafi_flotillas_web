class CreateMechanicalReviews < ActiveRecord::Migration[6.0]
  def change
    create_table :mechanical_reviews do |t|
      t.string :clave
      t.references :catalog_brand, null: false, foreign_key: true
      t.string :descripcion
      t.boolean :status

      t.timestamps
    end
  end
end
