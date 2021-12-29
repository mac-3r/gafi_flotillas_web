class CreateResponsibleReportResponsibles < ActiveRecord::Migration[6.0]
  def change
    create_view :responsible_report_responsibles
  end
end
