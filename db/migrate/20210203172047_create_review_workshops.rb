class CreateReviewWorkshops < ActiveRecord::Migration[6.0]
  def change
    create_table :review_workshops do |t|
      t.string :clave
      t.string :descripcion
      t.boolean :status

      t.timestamps
    end
  end
end
