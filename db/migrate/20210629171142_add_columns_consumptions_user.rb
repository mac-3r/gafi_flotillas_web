class AddColumnsConsumptionsUser < ActiveRecord::Migration[6.0]
  def change
    add_column :consumptions, :usuario_creador, :string
    add_column :consumptions, :usuario_modifico, :string
  end
end
