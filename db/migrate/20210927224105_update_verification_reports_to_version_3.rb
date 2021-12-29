class UpdateVerificationReportsToVersion3 < ActiveRecord::Migration[6.0]
  def change
    update_view :verification_reports, version: 3, revert_to_version: 2
  end
end
