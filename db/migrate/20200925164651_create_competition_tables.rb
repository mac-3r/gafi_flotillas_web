class CreateCompetitionTables < ActiveRecord::Migration[6.0]
  def change
    create_table :competition_tables do |t|
      t.references :catalog_branch, null: false, foreign_key: true
      t.string :gerencia_operaciones
      t.string :gerencia_corporativa
      t.string :direccion

      t.timestamps
    end
  end
end
