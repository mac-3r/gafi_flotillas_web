class AddColumnsCatalogCompanies < ActiveRecord::Migration[6.0]
  def change
    add_column :catalog_companies, :domicilio, :varchar
    add_column :catalog_companies, :codigo_postal, :integer
    add_column :catalog_companies, :telefono, :varchar
    add_column :catalog_companies, :rfc, :varchar
  end
end
