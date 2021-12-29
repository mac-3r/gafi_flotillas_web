class CreateResponsibleReportSinisters < ActiveRecord::Migration[6.0]
  def change
    create_view :responsible_report_sinisters
  end
end
