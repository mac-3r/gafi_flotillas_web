class CorrecionModelos < ActiveRecord::Migration[6.0]
  def change
    change_column :catalog_models, :descripcion, :string
  end
end
