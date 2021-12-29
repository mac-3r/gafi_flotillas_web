class Addcolumnsconceptbrand < ActiveRecord::Migration[6.0]
  def change
    add_column :concept_brands, :tipo_frecuencia, :integer
    add_column :concept_brands, :meses, :integer
    add_column :concept_brands, :fecha, :date
  end
end
