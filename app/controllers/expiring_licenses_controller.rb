class ExpiringLicensesController < ApplicationController
	authorize_resource :class => false
  
  def index
    session["company_exp_lic"] = ""
    session["branch_exp_lic"] = ""
    session["area_exp_lic"] = ""
    session["vehicle_exp_lic"] = ""
    @licencias = CatalogLicence.where("fecha_vencimiento <= ?", Time.zone.now.to_date.end_of_month).order(fecha_vencimiento: :asc)
  end

  def filtrado_licencias_expirar
    session["company_exp_lic"] = params[:catalog_company_id]
    session["branch_exp_lic"] = params[:catalog_branch_id]
    session["area_exp_lic"] = params[:area_id]
    session["vehicle_exp_lic"] = params[:vehicle_id]
    @licencias = CatalogLicence.licencias_expirar(session["company_exp_lic"], session["branch_exp_lic"], session["area_exp_lic"], session["vehicle_exp_lic"])
  end

  def excel_licencias_expirar
    require 'axlsx'
		package = Axlsx::Package.new
		workbook = package.workbook
    licencias = CatalogLicence.licencias_expirar(session["company_exp_lic"], session["branch_exp_lic"], session["area_exp_lic"], session["vehicle_exp_lic"])
    workbook.styles do |s|
      img = File.expand_path("#{Rails.root}/app/assets/images/excel_logo.png", __FILE__)
      col_widths= [3,30,30,30,30,30,30] 
			celda_tabla = s.add_style :bg_color => "BFBFBF", :fg_color => "00", :sz => 12, :border => { :style => :thin, :color => "00" }, :alignment => { :horizontal => :center, :vertical => :center ,:wrap_text => true}
			celda_cabecera= s.add_style :height => 25 ,:b => true, :sz => 16, :font_name => 'Arial', :alignment => { :horizontal => :right}
			celda_categoria = s.add_style :bg_color => "D9D9D9", :fg_color => "00", :sz => 12, :border => { :style => :thin, :color => "00" }, :alignment => { :horizontal => :left, :vertical => :center ,:wrap_text => true}
			celda_tabla_td = s.add_style :sz => 12, :border => { :style => :thin, :color => "00" }, :alignment => { :horizontal => :center, :vertical => :center ,:wrap_text => true}
      workbook.add_worksheet(name: "Licencias por expirar") do |sheet|
        sheet.add_image(:image_src => img, :noSelect => true, :noMove => true,) do |image|
					image.width = 105
					image.height = 137
					image.start_at 1, 0
				end
        sheet.add_row ["","Licencias expiradas y por expirar",""], :style => [nil, celda_cabecera, nil]
        sheet.add_row [""]
        sheet.add_row [""]
        sheet.add_row [""]
        sheet.add_row [""]
        sheet.add_row [""]
        sheet.add_row [""]
        sheet.add_row [""]
        sheet.add_row ["", "Clave", "Usuario", "No. Económico", "Tipo", "Número licencia", "Fecha vencimiento", ""], :style => [nil,celda_tabla,celda_tabla,celda_tabla,celda_tabla,celda_tabla,celda_tabla,celda_tabla]
        licencias.each do |catalog_licence|
          if catalog_licence.fecha_vencimiento < Time.zone.now.to_date
            bandera_expiracion = "Expirada"
            bandera_expirar = s.add_style :bg_color => "eb4034", :fg_color => "ff", :sz => 12, :border => { :style => :thin, :color => "00" }, :alignment => { :horizontal => :left, :vertical => :center ,:wrap_text => true}
          else
            bandera_expiracion = "Por expirar"
            bandera_expirar = s.add_style :bg_color => "ebc334", :fg_color => "00", :sz => 12, :border => { :style => :thin, :color => "00" }, :alignment => { :horizontal => :left, :vertical => :center ,:wrap_text => true}
          end
          sheet.add_row ["",catalog_licence.clave,"#{catalog_licence.user.name} #{catalog_licence.user.last_name}", catalog_licence.vehicle.numero_economico, catalog_licence.descripcion, catalog_licence.numero_licencia, catalog_licence.fecha_vencimiento, bandera_expiracion], :style => [nil,nil,nil,nil,nil, nil, nil, bandera_expirar]
        end
				sheet.merge_cells("B1:D1")
        sheet.column_widths *col_widths
      end
    end
    send_data package.to_stream.read, type: "application/xlsx", filename: "Licencias por expirar.xlsx"
  end
  
  
end
