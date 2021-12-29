class CreateTicketImgs < ActiveRecord::Migration[6.0]
  def change
    create_table :ticket_imgs do |t|
      t.string :imagen
      t.integer :tipo
      t.references :ticket_tire_battery, null: false, foreign_key: true

      t.timestamps
    end
  end
end
