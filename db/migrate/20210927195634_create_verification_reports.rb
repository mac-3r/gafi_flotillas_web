class CreateVerificationReports < ActiveRecord::Migration[6.0]
  def change
    create_view :verification_reports
  end
end
