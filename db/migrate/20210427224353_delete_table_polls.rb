class DeleteTablePolls < ActiveRecord::Migration[6.0]
  def change
    drop_table :polls
  end
end
