class CorreccionCatalogoPersonal < ActiveRecord::Migration[6.0]
  def change
    remove_column :catalog_personals, :apellido
    add_column :catalog_personals, :rfc, :string
    add_column :catalog_personals, :celular, :string 
    add_column :catalog_personals, :direccion, :string
    add_column :catalog_personals, :correo, :string
    add_column :catalog_personals, :estatus, :integer
  end
end
