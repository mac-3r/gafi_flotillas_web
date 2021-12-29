class AddActivoToInsurancepolicies < ActiveRecord::Migration[6.0]
  def change
    add_column :insurance_policies, :activo, :boolean, default: false
  end
end
