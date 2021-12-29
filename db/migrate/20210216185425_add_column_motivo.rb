class AddColumnMotivo < ActiveRecord::Migration[6.0]
  def change
    add_column :workshop_certifications, :motivo, :string
  end
end
