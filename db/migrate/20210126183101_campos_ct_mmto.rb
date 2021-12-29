class CamposCtMmto < ActiveRecord::Migration[6.0]
  def change
    add_column :maintenance_controls, :dias_taller, :integer
    add_column :maintenance_controls, :folio_factura, :string
    add_column :maintenance_controls, :uuid, :string
  end
end
