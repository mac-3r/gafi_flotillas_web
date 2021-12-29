class CreateBilledCompanies < ActiveRecord::Migration[6.0]
  def change
    create_table :billed_companies do |t|
      t.string :clave_jd
      t.string :nombre
      t.boolean :status

      t.timestamps
    end
  end
end
