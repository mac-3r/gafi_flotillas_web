class AddColumnComprado < ActiveRecord::Migration[6.0]
  def change
    add_column :budget_details, :cantidad_comprada, :integer, :default =>  0
    add_column :budget_administration_details, :cantidad_comprada, :integer, :default =>  0
    add_column :budget_distribution_details, :cantidad_comprada, :integer,  :default =>  0
  end
end
