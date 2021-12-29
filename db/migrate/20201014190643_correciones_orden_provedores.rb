class CorrecionesOrdenProvedores < ActiveRecord::Migration[6.0]
  def change
    remove_column :purchase_orders, :usuario
    remove_column :purchase_orders, :catalog_area_id
    remove_column :purchase_orders, :observaciones
    add_column :purchase_orders, :condicion, :string
    add_reference :purchase_orders, :catalog_vendor, foreign_key: true
    add_reference :purchase_orders, :catalog_model, foreign_key: true
    add_column :catalog_vendors, :contacto, :string
    add_column :catalog_vendors, :direccion, :string
    add_column :catalog_vendors, :rfc, :string
    add_column :catalog_vendors, :ciudad, :string
  end
end
