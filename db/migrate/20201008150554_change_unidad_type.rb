class ChangeUnidadType < ActiveRecord::Migration[6.0]
  def change
    change_column :budget_concepts, :unidad, :varchar

  end
end
