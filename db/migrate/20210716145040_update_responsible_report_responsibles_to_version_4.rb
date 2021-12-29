class UpdateResponsibleReportResponsiblesToVersion4 < ActiveRecord::Migration[6.0]
  def change
    update_view :responsible_report_responsibles, version: 4, revert_to_version: 3
  end
end
