class AddMotivoAdaptaciones < ActiveRecord::Migration[6.0]
  def change
    add_column :vehicle_adaptations, :motivo, :string
  end
end
