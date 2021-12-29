class Cambio < ActiveRecord::Migration[6.0]
  def change
    add_reference :budget_distribution_details, :budget_distribution, foreign_key: true
  end
end
