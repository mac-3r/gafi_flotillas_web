class LlaveForaneaDetalle < ActiveRecord::Migration[6.0]
  def change
    add_reference :purchase_details, :purchase_order, foreign_key: true
  end
end
