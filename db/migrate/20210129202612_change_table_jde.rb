class ChangeTableJde < ActiveRecord::Migration[6.0]
  def change
    add_reference :catalog_vendors, :user, foreign_key: true
    add_reference :catalog_personals, :user, foreign_key: true
    add_reference :responsables, :catalog_personal, foreign_key: true
  end
end
