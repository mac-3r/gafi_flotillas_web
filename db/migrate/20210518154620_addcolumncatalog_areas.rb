class AddcolumncatalogAreas < ActiveRecord::Migration[6.0]
  def change
    add_column :catalog_areas, :abreviacion, :string
  end
end
