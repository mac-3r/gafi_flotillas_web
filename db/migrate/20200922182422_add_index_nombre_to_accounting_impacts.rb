class AddIndexNombreToAccountingImpacts < ActiveRecord::Migration[6.0]
  def change
    add_index :accounting_impacts, [:nombre], unique: true
  end
end
