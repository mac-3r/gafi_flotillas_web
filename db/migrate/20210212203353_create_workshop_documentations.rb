class CreateWorkshopDocumentations < ActiveRecord::Migration[6.0]
  def change
    create_table :workshop_documentations do |t|
      t.references :workshop_certification, null: false, foreign_key: true
      t.string :ruta_archivo
      t.string :tipo

      t.timestamps
    end
  end
end
