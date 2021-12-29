class NuevosCampoVendor < ActiveRecord::Migration[6.0]
  def change
    add_column :catalog_vendors, :plazo, :string
    add_column :catalog_vendors, :instrumentopago, :string
    add_column :catalog_vendors, :compenlm, :string
  end
end
