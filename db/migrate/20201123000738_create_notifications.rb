class CreateNotifications < ActiveRecord::Migration[6.0]
  def change
    create_table :notifications do |t|
      t.text :notificacion
      t.text :texto
      t.boolean :visto, default: false

      t.timestamps
    end
    add_reference :notifications, :user
  end
end
