class UpdateVerificationReportsToVersion2 < ActiveRecord::Migration[6.0]
  def change
    update_view :verification_reports, version: 2, revert_to_version: 1
  end
end
