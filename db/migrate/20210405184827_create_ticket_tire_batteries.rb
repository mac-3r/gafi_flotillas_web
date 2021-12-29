class CreateTicketTireBatteries < ActiveRecord::Migration[6.0]
  def change
    create_table :ticket_tire_batteries do |t|
      t.references :vehicle, null: false, foreign_key: true
      t.string :dot
      t.date :fecha
      t.integer :estatus
      t.integer :tipo
      t.integer :cantidad

      t.timestamps
    end
  end
end
