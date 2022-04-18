class AddAceptaToUseranswer < ActiveRecord::Migration[6.0]
  def change
    add_column :user_answers, :acepta_realizo, :boolean, default: true
  end
end
