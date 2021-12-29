class AddColumnFirma < ActiveRecord::Migration[6.0]
  def change
    add_column :sales, :firma, :string
  end
end
