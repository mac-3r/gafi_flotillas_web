class CreateTableSectionsAreas < ActiveRecord::Migration[6.0]
  def change
    create_join_table :catalog_areas, :sections do |t|
      t.index [:catalog_area_id, :section_id]
      t.index [:section_id, :catalog_area_id]
    end
  end
end
