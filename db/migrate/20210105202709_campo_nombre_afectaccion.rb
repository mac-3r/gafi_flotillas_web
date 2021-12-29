class CampoNombreAfectaccion < ActiveRecord::Migration[6.0]
  def change
    add_index :accounting_impacts, [:cuenta_contable]
    remove_index :accounting_impacts, :nombre
  end
end
