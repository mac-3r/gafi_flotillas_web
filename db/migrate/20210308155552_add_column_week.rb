class AddColumnWeek < ActiveRecord::Migration[6.0]
  def change
    add_column :consumptions, :semana, :integer
  end
end
