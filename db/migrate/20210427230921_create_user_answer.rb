class CreateUserAnswer < ActiveRecord::Migration[6.0]
  def change
    create_table :user_answers do |t|
      t.references :user, null: false, foreign_key: true
      t.references :catalog_workshop, null: false, foreign_key: true
      t.references :vehicle, null: false, foreign_key: true
      t.references :service_order, null: false, foreign_key: true
      t.date :fecha_captura
      
      t.timestamps
    end
  end
end
