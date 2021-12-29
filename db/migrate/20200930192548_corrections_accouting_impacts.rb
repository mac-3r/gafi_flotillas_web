class CorrectionsAccoutingImpacts < ActiveRecord::Migration[6.0]
  def change
    add_column :accounting_impacts, :cuenta_contable, :varchar
    remove_column :accounting_impacts, :mantenimiento_equipo
    remove_column :accounting_impacts, :mantenimiento_maquinaria
    remove_column :accounting_impacts, :combustible
    remove_column :accounting_impacts, :plaqueo
    remove_column :accounting_impacts, :seguro
    remove_column :accounting_impacts, :permiso
  end
end
