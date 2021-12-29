class ResponsibleReportResponsible < ActiveRecord::Base
  
    def readonly?
        true
    end

    def self.responsables_matriz(fecha_inicio, fecha_fin, cedis, tipo_siniestro, area)
        # fecha_fin = '2021-09-30'
        # fecha_inicio = '2020-10-01'
		cons_cedis = CatalogBranch.find_by(id: cedis)
        #byebug
        cadena = "fecha between '#{fecha_inicio.strftime("%Y-%m-%d")}' and '#{fecha_fin.strftime("%Y-%m-%d")}'"
        if cedis != "" and !cedis.nil?
            cadena += " and sucursal = '#{cons_cedis.decripcion}'"
        end

        if area != "" and !area.nil?
            cadena += " and catalog_area_id = '#{area}'"
        end

        if tipo_siniestro != "" and !tipo_siniestro.nil?
            cadena += " and id_tipo_siniestro = #{tipo_siniestro}"
            consulta = ResponsibleReportSinister.where(cadena).order(responsable: :asc)
        else
            consulta = ResponsibleReportResponsible.where(cadena).order(responsable: :asc)
        end
        arreglo = Array.new
        pivote_resp = ""
        hash = Hash.new
        consulta.each_with_index do |cons, index|
            #byebug
            if index == 0
                pivote_resp = cons.responsable
                hash["responsable"] = cons.responsable
                hash["enero"] = ""
                hash["febrero"] = ""
                hash["marzo"] = ""
                hash["abril"] = ""
                hash["mayo"] = ""
                hash["junio"] = ""
                hash["julio"] = ""
                hash["agosto"] = ""
                hash["septiembre"] = ""
                hash["octubre"] = ""
                hash["noviembre"] = ""
                hash["diciembre"] = ""
                if cons.mes_numero == "01"
                    hash["enero"] = cons.total_siniestros
                end
                if cons.mes_numero == "02"
                    hash["febrero"] = cons.total_siniestros
                end
                if cons.mes_numero == "03"
                    hash["marzo"] = cons.total_siniestros
                end
                if cons.mes_numero == "04"
                    hash["abril"] = cons.total_siniestros
                end
                if cons.mes_numero == "05"
                    hash["mayo"] = cons.total_siniestros
                end
                if cons.mes_numero == "06"
                    hash["junio"] = cons.total_siniestros
                end
                if cons.mes_numero == "07"
                    hash["julio"] = cons.total_siniestros
                end
                if cons.mes_numero == "08"
                    hash["agosto"] = cons.total_siniestros
                end
                if cons.mes_numero == "09"
                    hash["septiembre"] = cons.total_siniestros
                end
                if cons.mes_numero == "10"
                    hash["octubre"] = cons.total_siniestros
                end
                if cons.mes_numero == "11"
                    hash["noviembre"] = cons.total_siniestros
                end
                if cons.mes_numero == "12"
                    hash["diciembre"] = cons.total_siniestros
                end
            else
                if pivote_resp == cons.responsable
                    if cons.mes_numero == "01"
                        hash["enero"] = cons.total_siniestros
                    end
                    if cons.mes_numero == "02"
                        hash["febrero"] = cons.total_siniestros
                    end
                    if cons.mes_numero == "03"
                        hash["marzo"] = cons.total_siniestros
                    end
                    if cons.mes_numero == "04"
                        hash["abril"] = cons.total_siniestros
                    end
                    if cons.mes_numero == "05"
                        hash["mayo"] = cons.total_siniestros
                    end
                    if cons.mes_numero == "06"
                        hash["junio"] = cons.total_siniestros
                    end
                    if cons.mes_numero == "07"
                        hash["julio"] = cons.total_siniestros
                    end
                    if cons.mes_numero == "08"
                        hash["agosto"] = cons.total_siniestros
                    end
                    if cons.mes_numero == "09"
                        hash["septiembre"] = cons.total_siniestros
                    end
                    if cons.mes_numero == "10"
                        hash["octubre"] = cons.total_siniestros
                    end
                    if cons.mes_numero == "11"
                        hash["noviembre"] = cons.total_siniestros
                    end
                    if cons.mes_numero == "12"
                        hash["diciembre"] = cons.total_siniestros
                    end
                else
                    arreglo.push(hash)
                    #byebug
                    pivote_resp = cons.responsable
                    hash = Hash.new
                    hash["responsable"] = cons.responsable
                    hash["enero"] = ""
                    hash["febrero"] = ""
                    hash["marzo"] = ""
                    hash["abril"] = ""
                    hash["mayo"] = ""
                    hash["junio"] = ""
                    hash["julio"] = ""
                    hash["agosto"] = ""
                    hash["septiembre"] = ""
                    hash["octubre"] = ""
                    hash["noviembre"] = ""
                    hash["diciembre"] = ""
                    if cons.mes_numero == "01"
                        hash["enero"] = cons.total_siniestros
                    end
                    if cons.mes_numero == "02"
                        hash["febrero"] = cons.total_siniestros
                    end
                    if cons.mes_numero == "03"
                        hash["marzo"] = cons.total_siniestros
                    end
                    if cons.mes_numero == "04"
                        hash["abril"] = cons.total_siniestros
                    end
                    if cons.mes_numero == "05"
                        hash["mayo"] = cons.total_siniestros
                    end
                    if cons.mes_numero == "06"
                        hash["junio"] = cons.total_siniestros
                    end
                    if cons.mes_numero == "07"
                        hash["julio"] = cons.total_siniestros
                    end
                    if cons.mes_numero == "08"
                        hash["agosto"] = cons.total_siniestros
                    end
                    if cons.mes_numero == "09"
                        hash["septiembre"] = cons.total_siniestros
                    end
                    if cons.mes_numero == "10"
                        hash["octubre"] = cons.total_siniestros
                    end
                    if cons.mes_numero == "11"
                        hash["noviembre"] = cons.total_siniestros
                    end
                    if cons.mes_numero == "12"
                        hash["diciembre"] = cons.total_siniestros
                    end
                end
            end
            if index+1 == consulta.length
                arreglo.push(hash)
            end
        end
        #byebug
        return arreglo
    end
end