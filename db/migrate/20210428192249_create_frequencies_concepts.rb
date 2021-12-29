class CreateFrequenciesConcepts < ActiveRecord::Migration[6.0]
  def change
    create_view :frequencies_concepts
  end
end
