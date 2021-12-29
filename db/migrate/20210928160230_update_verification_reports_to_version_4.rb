class UpdateVerificationReportsToVersion4 < ActiveRecord::Migration[6.0]
  def change
    update_view :verification_reports, version: 4, revert_to_version: 3
  end
end
