class AddcolumnsMaintennace < ActiveRecord::Migration[6.0]
  def change
    add_column :maintenance_controls, :estatus, :integer
    add_column :concept_descriptions, :bujias,:boolean
    add_column :service_orders,:motivo_rechazo, :string
  end
end
