class CampoRechazo < ActiveRecord::Migration[6.0]
  def change
    add_column :budget_concepts, :motivo_rechazo, :string
    add_column :budget_administrations, :motivo_rechazo, :string
    add_column :budget_distributions, :motivo_rechazo, :string
  end
end
