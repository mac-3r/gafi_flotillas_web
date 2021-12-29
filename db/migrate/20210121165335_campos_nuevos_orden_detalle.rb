class CamposNuevosOrdenDetalle < ActiveRecord::Migration[6.0]
  def change
    add_column :purchase_details, :tipo, :integer
    add_column :purchase_details, :budget_detail_id, :integer
  end
end
