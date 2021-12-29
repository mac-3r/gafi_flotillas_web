class NuevoCampoAfeccion < ActiveRecord::Migration[6.0]
  def change
    add_reference :accounting_impacts, :catalog_area, foreign_key: true
  end
end
