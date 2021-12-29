class RemoveDot < ActiveRecord::Migration[6.0]
  def change
    remove_column :ticket_tire_batteries, :dot, :string
    add_column :ticket_imgs, :dot, :string
  end
end
