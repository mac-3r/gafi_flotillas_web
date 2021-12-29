class CreateBinnacles < ActiveRecord::Migration[6.0]
  def change
    create_view :binnacles
  end
end
