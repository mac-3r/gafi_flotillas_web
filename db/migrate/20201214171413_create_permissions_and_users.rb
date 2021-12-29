class CreatePermissionsAndUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :permissions_and_users do |t|
      t.belongs_to :permission, index: true
      t.belongs_to :user, index: true
    end
  end
end
