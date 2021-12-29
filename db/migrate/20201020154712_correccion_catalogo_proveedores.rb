class CorreccionCatalogoProveedores < ActiveRecord::Migration[6.0]
  def change
    add_column :catalog_vendors, :estatus, :integer
    add_column :catalog_vendors, :razonsocial, :string
    add_column :catalog_vendors, :correo, :string
    remove_column :catalog_vendors, :ciudad
  end
end
