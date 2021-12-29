class CreateBimonthlyImg < ActiveRecord::Migration[6.0]
  def change
    create_table :bimonthly_imgs do |t|
      t.string :imagen
      t.integer :tipo
      t.references :bimonthly_verification, null: true, foreign_key: true
      t.references :vehicles, null: true, foreign_key: true
      t.timestamps
    end
  end
end
