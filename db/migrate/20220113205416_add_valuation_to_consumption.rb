class AddValuationToConsumption < ActiveRecord::Migration[6.0]
  def change
    add_reference :consumptions, :valuation
  end
end
