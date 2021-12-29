class CreateCatalogAreas < ActiveRecord::Migration[6.0]
  def change
    create_table :catalog_areas do |t|
      t.string :descripcion
      t.boolean :status

      t.timestamps
    end
  end
end
