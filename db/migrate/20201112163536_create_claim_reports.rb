class CreateClaimReports < ActiveRecord::Migration[6.0]
  def change
    create_view :claim_reports
  end
end
