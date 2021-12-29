class TablaComptCambios < ActiveRecord::Migration[6.0]
  def change
    remove_column :competition_tables, :autorizante
    add_reference :competition_tables, :catalog_role, foreign_key: true
  end
end
