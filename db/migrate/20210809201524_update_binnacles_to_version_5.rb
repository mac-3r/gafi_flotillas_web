class UpdateBinnaclesToVersion5 < ActiveRecord::Migration[6.0]
  def change
    update_view :binnacles, version: 5, revert_to_version: 3
  end
end
