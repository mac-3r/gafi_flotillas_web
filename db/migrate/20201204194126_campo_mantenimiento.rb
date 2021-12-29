class CampoMantenimiento < ActiveRecord::Migration[6.0]
  def change
    add_reference :maintenance_details, :maintenance_log, foreign_key: true
  end
end
