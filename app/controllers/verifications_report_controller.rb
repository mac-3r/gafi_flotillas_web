class VerificationsReportController < ApplicationController

	before_action :validacion_menu
	authorize_resource :class => false
  def index
    session["company_verif"] = ""
    session["branch_verif"] = ""
    session["area_verif"] = ""
    session["vehicle_verif"] = ""
    session["fecha_ini_verif"] = ""
    session["fecha_fin_verif"] = ""
    @verificaciones = VerificationReports.where.not(estatus: 0).order(fecha_auditoria: :desc)
  end

  def filtrado_verificaciones
    session["company_verif"] = params[:catalog_company_id]
    session["branch_verif"] = params[:catalog_branch_id]
    session["area_verif"] = params[:area_id]
    session["vehicle_verif"] = params[:vehicle_id]
    session["fecha_ini_verif"] = params[:start_date]
    session["fecha_fin_verif"] = params[:end_date]
    @verificaciones = VerificationReports.consulta_verificaciones(session["company_verif"], session["branch_verif"], session["area_verif"], session["vehicle_verif"], session["fecha_ini_verif"], session["fecha_fin_verif"])
  end

  def excel_verificaciones
    require 'axlsx'
		package = Axlsx::Package.new
		workbook = package.workbook
    verificaciones = VerificationReports.consulta_verificaciones(session["company_verif"], session["branch_verif"], session["area_verif"], session["vehicle_verif"], session["fecha_ini_verif"], session["fecha_fin_verif"])
    workbook.styles do |s|
      img = File.expand_path("#{Rails.root}/app/assets/images/excel_logo.png", __FILE__)
      col_widths= [3,30,30,30,30,30,30] 
			celda_tabla = s.add_style :bg_color => "BFBFBF", :fg_color => "00", :sz => 12, :border => { :style => :thin, :color => "00" }, :alignment => { :horizontal => :center, :vertical => :center ,:wrap_text => true}
			celda_cabecera= s.add_style :height => 25 ,:b => true, :sz => 16, :font_name => 'Arial', :alignment => { :horizontal => :right}
			celda_categoria = s.add_style :bg_color => "D9D9D9", :fg_color => "00", :sz => 12, :border => { :style => :thin, :color => "00" }, :alignment => { :horizontal => :left, :vertical => :center ,:wrap_text => true}
			celda_tabla_td = s.add_style :sz => 12, :border => { :style => :thin, :color => "00" }, :alignment => { :horizontal => :center, :vertical => :center ,:wrap_text => true}
      workbook.add_worksheet(name: "Reportes vehiculares") do |sheet|
        sheet.add_image(:image_src => img, :noSelect => true, :noMove => true,) do |image|
					image.width = 105
					image.height = 137
					image.start_at 1, 0
				end
        sheet.add_row ["","Concentrado de auditorías y reportes vehiculares",""], :style => [nil, celda_cabecera, nil]
        sheet.add_row [""]
        sheet.add_row [""]
        sheet.add_row [""]
        sheet.add_row [""]
        sheet.add_row [""]
        sheet.add_row [""]
        sheet.add_row [""]
        sheet.add_row ["", "No. económico", "Tipo de vehículo", "Área", "Cedis", "Falla encontrada", "Tipo de reporte", "Fecha de auditoría", "Tipo de reparación", "Concepto", "Estatus", "Atiende"], :style => [nil,celda_tabla,celda_tabla,celda_tabla,celda_tabla,celda_tabla,celda_tabla,celda_tabla,celda_tabla,celda_tabla,celda_tabla,celda_tabla]
        verificaciones.each do |verificacion|
          if verificacion.estatus == 1
            estatus = "Mal estado"
          elsif verificacion.estatus == 2
            estatus = "No se recibe"
          end
          sheet.add_row ["",verificacion.numero_economico,verificacion.tipo_vehiculo, verificacion.area_vehiculo, verificacion.cedis_vehiculo, verificacion.falla_encontrada, "Auditoría", verificacion.fecha_auditoria, verificacion.tipo_reparacion, verificacion.concepto, estatus, verificacion.atiende], :style => [nil,nil,nil,nil,nil, nil, nil, nil,nil,nil,nil,nil]
        end
				sheet.merge_cells("B1:D1")
        sheet.column_widths *col_widths
      end
    end
    send_data package.to_stream.read, type: "application/xlsx", filename: "Auditorías y reportes vehiculares.xlsx"
  end

  private
		def validacion_menu
      session["menu1"] = "Maestro de vehículos"
			session["menu2"] = "Reporte de auditorías"
		end
end
