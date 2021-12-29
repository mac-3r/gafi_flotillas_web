class CentroCoNuevo < ActiveRecord::Migration[6.0]
  def change
    add_column :cost_centers, :centro_costo, :string
  end
end
