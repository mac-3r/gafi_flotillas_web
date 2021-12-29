class AutorizanteConsumptions < ActiveRecord::Migration[6.0]
  def change
    add_column :consumptions, :usuario_autorizante_id, :integer
  end
end
