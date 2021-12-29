class CreateJdeLogs < ActiveRecord::Migration[6.0]
  def change
    create_table :jde_logs do |t|
      t.date :fecha
      t.time :hora
      t.text :json_enviado
      t.text :respuesta

      t.timestamps
    end
  end
end
