class CreateLicencesPicture < ActiveRecord::Migration[6.0]
  def change
    create_table :licences_pictures do |t|
      t.string :imagen
      t.string :tipo
      t.references :user, null: false, foreign_key: true
      t.references :vehicle, null: false, foreign_key: true
      t.references :catalog_licence, null: false, foreign_key: true
      t.timestamps
    end
    add_reference :catalog_licences, :user, foreign_key: true
  end
end
