class AddCompanyToConsumptions < ActiveRecord::Migration[6.0]
  def change
    add_reference :consumptions, :company
  end
end
