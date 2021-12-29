class CambioCombustible < ActiveRecord::Migration[6.0]
  def change
    add_reference :consumptions, :catalog_vendor, foreign_key: true
  end
end
