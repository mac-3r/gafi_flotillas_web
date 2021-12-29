class ChangeColumnServiceorders < ActiveRecord::Migration[6.0]
  def change
    change_column :service_orders, :fecha_revision_propuesta, :datetime
  end
end
