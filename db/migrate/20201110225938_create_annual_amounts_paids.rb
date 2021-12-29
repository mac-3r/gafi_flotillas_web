class CreateAnnualAmountsPaids < ActiveRecord::Migration[6.0]
  def change
    create_table :annual_amounts_paids do |t|
      t.float :cantidad
      t.integer :anio_inicio
      t.integer :anio_fin

      t.timestamps
    end
  end
end
