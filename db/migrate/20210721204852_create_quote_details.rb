class CreateQuoteDetails < ActiveRecord::Migration[6.0]
  def change
    create_table :quote_details do |t|
      t.string :descripcion
      t.decimal :precio
      t.references :quote, null: false, foreign_key: true

      t.timestamps
    end
  end
end
