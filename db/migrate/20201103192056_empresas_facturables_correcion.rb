class EmpresasFacturablesCorrecion < ActiveRecord::Migration[6.0]
  def change
    add_column :billed_companies, :domicilio, :string 
    add_column :billed_companies, :rfc, :string
    add_column :billed_companies, :telefono, :string
  end
end
