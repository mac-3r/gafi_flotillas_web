class AddColumnAbrvComp < ActiveRecord::Migration[6.0]
  def change
    add_column :catalog_companies, :abreviatura, :string
  end
end
