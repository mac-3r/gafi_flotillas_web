class AddFieldsToVerification < ActiveRecord::Migration[6.0]
  def change
    add_column :checklist_responses, :cedis_entrega, :string
    add_column :checklist_responses, :cedis_recibe, :string
    add_column :checklist_responses, :fecha_entrega, :date
    add_column :checklist_responses, :fecha_recibe, :date
    add_column :checklist_responses, :nombre_recibe, :string
    add_column :checklist_responses, :puesto_recibe, :string
    add_column :checklist_responses, :num_licencia, :string
    add_column :checklist_responses, :tipo_licencia, :string
    add_column :checklist_responses, :vigencia_licencia, :date
    add_column :checklist_responses, :nombre_entrega, :string
    add_column :checklist_responses, :puesto_entrega, :string
  end
end
