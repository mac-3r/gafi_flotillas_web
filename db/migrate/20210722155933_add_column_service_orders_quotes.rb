class AddColumnServiceOrdersQuotes < ActiveRecord::Migration[6.0]
  def change
      add_reference :quotes, :catalog_vendor, foreign_key: true,null: true
      change_column :quotes, :catalog_workshop_id, :integer, null:true
      add_column :service_orders, :cotizacion, :boolean, default:false
  end
end
