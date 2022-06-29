class Consumption < ApplicationRecord
    has_many :vehicle_consumptions
    belongs_to :catalog_branch, optional: true
    belongs_to :catalog_vendor
    belongs_to :valuation, optional: true
    enum estatus: ["Pendiente", "Por autorizar", "Autorizado", "Rechazado"]
    has_one_attached :factura
    has_one_attached :pdf
    scope :por_fecha_inicio, -> (fecha_inicio) {where("fecha_inicio >= ?", fecha_inicio)}
    scope :por_fecha_fin, -> (fecha_fin) {where("fecha_fin <= ?", fecha_fin)}
    scope :por_cedis, -> (cedis) {where(catalog_branches: {id: cedis})}


    def enviar_json(current_user)
        @current_user = current_user
        @objeto_principal = []
        @polizaInput = []
        @poliza = []
        @base = []
        @asientoDeDiario = []
        @info_adicional = []
        impuestos_totales = 0
        hash_principal = Hash.new
        hash_polizaInput = Hash.new
        hash_poliza = Hash.new
        hash_base = Hash.new
        hash_info_adicional = Hash.new
        hash_poliza["usuario"] = @current_user.correo_combustibles
        hash_poliza["numeroTransaccion"] = "1"
        hash_poliza["numeroLinea"] = "1000"
        hash_poliza["numeroBatch"] = "0"
        cat_company = CatalogCompany.find_by(id: self.company_id)
        hash_poliza["compañiaDocumento"] = cat_company.clave
        #hash_poliza["compañiaDocumento"] = "00001"
        hash_poliza["tipoDocumento"] = "PV"
        hash_poliza["numeroProveedor"] = self.catalog_vendor.clave #"49965"#self.vehicle_consumptions[0].vehicle.catalog_company.clave    sacar de la relacion
        hash_poliza["numeroBeneficiario"] = self.catalog_vendor.clave  #"49965"#self.vehicle_consumptions[0].vehicle.catalog_company.clave  sacar de la relacion con proveedor numero de (proveedor)
        hash_poliza["fechaFactura"] = "1#{self.fecha_factura.strftime("%y")}#{(self.fecha_factura).strftime("%j")}"
        hash_poliza["fechaEfectiva"] = "1#{self.created_at.strftime("%y")}#{(self.created_at).strftime("%j")}"
        hash_poliza["fechaVencimiento"] = "" #"120252" 
        hash_poliza["fechaDescuento"] = "1#{self.fecha_factura.strftime("%y")}#{(self.fecha_factura).strftime("%j")}" #"120252"
        hash_poliza["fechaLM"] = "1#{self.fecha_aplicacion.strftime("%y")}#{(self.fecha_aplicacion).strftime("%j")}"
        hash_poliza["añoFiscal"] = "0"
        #hash_poliza["sigloFiscal"] = "21"
        hash_poliza["sigloFiscal"] = "20"
        hash_poliza["periodoFiscal"] = "0"
        hash_poliza["compañia"] = self.vehicle_consumptions[0].vehicle.catalog_company.clave#"DYENCALADA"
        hash_poliza["tipoBatch"] = "V"
        hash_poliza["transaccionBalanceada"] = "Y"
        hash_poliza["estatusDePago"] = "H"
        valuation = ValuationsBranch.find_by(catalog_vendor_id: self.catalog_vendor_id, catalog_branch_id: self.catalog_branch_id)
        puts "**************************** Valuation: #{valuation}"

        if valuation
            valor_iva = valuation.valuation.valor / 100
        else
            valor_iva = 0.16
        end
        
        #imponible = (self.monto.to_f - self.impuestos.to_f).round(2)
        #byebug
        imponible = (self.impuestos.to_f / valor_iva)
        imponible_global = ((imponible) * 100).to_i

        acumulado_impuesto_base_cero = 0
        acumulado_monto_total_base_cero = 0
        acumulado_imponible_base_cero = 0
        acumulado_impuesto = 0
        acumulado_monto_total = 0
        acumulado_imponible = 0


        bandera_base_cero = false
        bandera_impuesto = self.impuestos.round(2) / valor_iva
        if ((self.monto - self.impuestos).round(2) - bandera_impuesto) > 0
            bandera_base_cero = true
        end
        valor_importe_global = (((self.impuestos / valor_iva).round(2) * (1 + valor_iva)).round(2) * 100).round(2)
        hash_poliza["importe"] = (valor_importe_global.to_f).to_i
        hash_poliza["importePendiente"] = (valor_importe_global.to_f).to_i
        hash_poliza["importeImponible"] = ((self.impuestos / valor_iva).round(2) * 100).round(2).to_i

        hash_poliza["importeImpuesto"] = (self.impuestos.to_f.floor(2)* 100).round
        hash_poliza["tasaFiscal"] = "IVA15GAS"
        hash_poliza["explicacionFiscal"] = "V"
        hash_poliza["tipoMoneda"] = "D"
        hash_poliza["moneda"] = "MXP"
        hash_poliza["glClass"] = self.catalog_vendor.compenlm
        #hash_poliza["cuentaBancaria"] = "00000000" #sacar de vendors -------------------------------------- la agarre de vendors
        #hash_poliza["cuentaBancaria"] = ""
        hash_poliza["modoDeCuenta"] = "2"
        #hash_poliza["unidadDeNegocio"] = self.catalog_branch.unidad_negocio
        area_mayor = nil
        bandera_total = 0
        CatalogArea.all.each do |area|
            cuenta = self.vehicle_consumptions.joins(:vehicle).where(vehicles: {catalog_area_id: area.id}).count
            if cuenta > 0
                suma = self.vehicle_consumptions.joins(:vehicle).where(vehicles: {catalog_area_id: area.id}).sum(:monto)
                if suma > bandera_total
                    bandera_total = suma
                    area_mayor = area.clave
                end
            end
        end
        #hash_poliza["unidadDeNegocio"] = "09990706"
        hash_poliza["unidadDeNegocio"] = "#{self.catalog_branch.unidad_negocio}#{area_mayor}"
        #byebug
        hash_poliza["plazo"] = self.catalog_vendor.plazo #sacar de vendors -----------------------------------------
        hash_poliza["factura"] = self.n_factura # "145525"#self.n_factura
        hash_poliza["nameRemark"] = "#{self.catalog_branch.abreviacion} COMB #{self.fecha_inicio.strftime("%d")}-#{self.fecha_fin.strftime("%d")} #{ I18n.l(self.fecha_fin, format: '%B') }"
        hash_poliza["instrumentoDePago"] = self.catalog_vendor.instrumentopago
        hash_poliza["originador"] = @current_user.correo_combustibles
        hash_poliza["usuarioActualizacion"] = @current_user.correo_combustibles
        hash_poliza["idPrograma"] = self.id
        hash_poliza["fechaActualizacion"] = "1#{Time.zone.now.strftime("%y")}#{(Time.zone.now).strftime("%j")}" #"1#{self.updated_at.strftime("%y")}#{(self.updated_at).strftime("%j")}"
        hash_poliza["horaActualizacion"] = Time.zone.now.strftime("%H%M%S")
        hash_poliza["estacionDeTrabajo"] = "WEB91a"


        if bandera_base_cero == true
            hash_base["usuario"] = @current_user.correo_combustibles
            hash_base["numeroTransaccion"] = "1"
            hash_base["numeroLinea"] = "2000"
            hash_base["numeroBatch"] = "0"
            hash_base["compañiaDocumento"] = "00001"
            hash_base["tipoDocumento"] = "PV"
            hash_base["numeroProveedor"] = self.catalog_vendor.clave#"49965"#self.vehicle_consumptions[0].vehicle.catalog_company.clave    sacar de la relacion
            hash_base["numeroBeneficiario"] = self.catalog_vendor.clave #"49965"#self.vehicle_consumptions[0].vehicle.catalog_company.clave  sacar de la relacion con proveedor numero de (proveedor)
            hash_base["fechaFactura"] = "1#{self.fecha_factura.strftime("%y")}#{(self.fecha_factura).strftime("%j")}"
            hash_base["fechaEfectiva"] = "1#{self.created_at.strftime("%y")}#{(self.created_at).strftime("%j")}"
            hash_base["fechaVencimiento"] = "" #"120252" 
            hash_base["fechaDescuento"] = "1#{self.fecha_factura.strftime("%y")}#{(self.fecha_factura).strftime("%j")}" #"120252"
            hash_base["fechaLM"] = "1#{self.fecha_aplicacion.strftime("%y")}#{(self.fecha_aplicacion).strftime("%j")}"
            hash_base["añoFiscal"] = "0"
            hash_base["sigloFiscal"] = "20"
            hash_base["periodoFiscal"] = "0"
            hash_base["compañia"] = self.vehicle_consumptions[0].vehicle.catalog_company.clave#"DYENCALADA"
            hash_base["tipoBatch"] = "V"
            hash_base["transaccionBalanceada"] = "Y"
            hash_base["estatusDePago"] = "H"
            importes = (((self.monto - self.impuestos).round(2) - bandera_impuesto) * 100).round
            hash_base["importe"] =  importes
            hash_base["importePendiente"] =   importes 
            hash_base["importeImponible"] =  importes
            hash_base["importeImpuesto"] = "0"
            hash_base["tasaFiscal"] = "IVA0GAS"
            hash_base["explicacionFiscal"] = "V"
            hash_base["tipoMoneda"] = "D"
            hash_base["moneda"] = "MXP"
            hash_base["glClass"] = self.catalog_vendor.compenlm
            hash_base["modoDeCuenta"] = "2"
            hash_base["unidadDeNegocio"] = "#{self.catalog_branch.unidad_negocio}#{area_mayor}"
            hash_base["plazo"] = self.catalog_vendor.plazo
            hash_base["factura"] = self.n_factura 
            hash_base["nameRemark"] = "#{self.catalog_branch.abreviacion} COMB #{self.fecha_inicio.strftime("%d")}-#{self.fecha_fin.strftime("%d")} #{ I18n.l(self.fecha_fin, format: '%B') }"
            hash_base["instrumentoDePago"] = self.catalog_vendor.instrumentopago
            hash_base["originador"] = @current_user.correo_combustibles
            hash_base["usuarioActualizacion"] = @current_user.correo_combustibles
            hash_base["idPrograma"] = self.id
            hash_base["fechaActualizacion"] = "1#{Time.zone.now.strftime("%y")}#{(Time.zone.now).strftime("%j")}"
            hash_base["horaActualizacion"] = Time.zone.now.strftime("%H%M%S")
            hash_base["estacionDeTrabajo"] = "WEB91a"
            hash_polizaInput["poliza"] = hash_poliza,hash_base
        else
            @poliza << hash_poliza
            hash_polizaInput["poliza"] = @poliza
        end

        # if self.base == true
        #     hash_base["usuario"] = @current_user.correo_combustibles
        #     hash_base["numeroTransaccion"] = "1"
        #     hash_base["numeroLinea"] = "2000"
        #     hash_base["numeroBatch"] = "0"
        #     hash_base["compañiaDocumento"] = "00001"
        #     hash_base["tipoDocumento"] = "PV"
        #     hash_base["numeroProveedor"] = self.catalog_vendor.clave#"49965"#self.vehicle_consumptions[0].vehicle.catalog_company.clave    sacar de la relacion
        #     hash_base["numeroBeneficiario"] = self.catalog_vendor.clave #"49965"#self.vehicle_consumptions[0].vehicle.catalog_company.clave  sacar de la relacion con proveedor numero de (proveedor)
        #     hash_base["fechaFactura"] = "1#{self.fecha_factura.strftime("%y")}#{(self.fecha_factura).strftime("%j")}"
        #     hash_base["fechaEfectiva"] = "1#{self.created_at.strftime("%y")}#{(self.created_at).strftime("%j")}"
        #     hash_base["fechaVencimiento"] = "" #"120252" 
        #     hash_base["fechaDescuento"] = "1#{self.fecha_factura.strftime("%y")}#{(self.fecha_factura).strftime("%j")}" #"120252"
        #     hash_base["fechaLM"] = "1#{self.fecha_aplicacion.strftime("%y")}#{(self.fecha_aplicacion).strftime("%j")}"
        #     hash_base["añoFiscal"] = "0"
        #     hash_base["sigloFiscal"] = "20"
        #     hash_base["periodoFiscal"] = "0"
        #     hash_base["compañia"] = self.vehicle_consumptions[0].vehicle.catalog_company.clave#"DYENCALADA"
        #     hash_base["tipoBatch"] = "V"
        #     hash_base["transaccionBalanceada"] = "Y"
        #     hash_base["estatusDePago"] = "H"
        #     hash_base["importe"] = ((base.round(2) * 100).to_i).to_s
        #     hash_base["importePendiente"] = ((base.round(2) * 100).to_i).to_s
        #     hash_base["importeImponible"] = ((base.round(2) * 100).to_i).to_s
        #     hash_base["importeImpuesto"] = "0"
        #     hash_base["tasaFiscal"] = "IVA0GAS"
        #     hash_base["explicacionFiscal"] = "V"
        #     hash_base["tipoMoneda"] = "D"
        #     hash_base["moneda"] = "MXP"
        #     hash_base["glClass"] = self.catalog_vendor.compenlm
        #     hash_base["modoDeCuenta"] = "2"
        #     hash_base["unidadDeNegocio"] = self.catalog_branch.unidad_negocio
        #     hash_base["plazo"] = self.catalog_vendor.plazo
        #     hash_base["factura"] = self.n_factura 
        #     hash_base["nameRemark"] = "#{self.catalog_branch.abreviacion} COMB #{self.fecha_inicio.strftime("%d")}-#{self.fecha_fin.strftime("%d")} #{ I18n.l(self.fecha_fin, format: '%B') }"
        #     hash_base["instrumentoDePago"] = self.catalog_vendor.instrumentopago
        #     hash_base["originador"] = @current_user.correo_combustibles
        #     hash_base["usuarioActualizacion"] = @current_user.correo_combustibles
        #     hash_base["idPrograma"] = self.id
        #     hash_base["fechaActualizacion"] = "1#{Time.zone.now.strftime("%y")}#{(Time.zone.now).strftime("%j")}"
        #     hash_base["horaActualizacion"] = Time.zone.now.strftime("%H%M%S")
        #     hash_base["estacionDeTrabajo"] = "WEB91a"
        #     hash_polizaInput["poliza"] = hash_poliza,hash_base
        # else
        #     @poliza << hash_poliza
        #     hash_polizaInput["poliza"] = @poliza
        # end
      
            #byebug
            @costos = VehicleConsumption.joins(:consumption).joins(:vehicle).where(consumptions: {id: self.id}).group("vehicles.catalog_area_id, consumptions.catalog_branch_id, vehicles.catalog_branch_id").select("sum(vehicle_consumptions.monto) as monto, sum(vehicle_consumptions.impuestos) as impuestos, consumptions.catalog_branch_id as cediscarga, vehicles.catalog_branch_id as cedisorigen, vehicles.catalog_area_id as catalog_area_id")
            @costos.each_with_index do |ac,index|

                #if @costos != []
                hash_asientoDeDiario = Hash.new 
                hash_asientoDeDiario["numeroLinea"] = "#{index+1}000"
                hash_asientoDeDiario["numeroBatch"] = "0"
                hash_asientoDeDiario["fechaLM"] = "1#{self.fecha_fin.strftime("%y")}#{(self.fecha_fin).strftime("%j")}"
                hash_asientoDeDiario["tipoBatch"] = "V"
                #hash_asientoDeDiario["compañia"] = self.vehicle_consumptions[0].vehicle.catalog_company.clave
                hash_asientoDeDiario["compañia"] = hash_poliza["compañia"]
                puts "**************************** Catalogo Area: #{ac.catalog_area_id}"
                catalogo = CatalogArea.find_by(id: ac.catalog_area_id)
                #byebug
                if catalogo.descripcion == "Operaciones"
                    if catalogo == nil
                        @mensaje_error  = ["No se encontro un Área con los datos proporcionados, por favor revise la información. Folio: #{self.folio}"]
                        return [@mensaje_error,false]
                    end

                end
                puts "************************************ valuation 2: #{valuation}"        
                #byebug
                if valuation
                    cedis_de_carga = CatalogBranch.find_by(id: ac.cediscarga)
                    puts "**************************cedis_de_carga: #{cedis_de_carga}"        

                    if valuation.catalog_branch.catalog_company_id == cedis_de_carga.catalog_company_id
                        tasa_costo = ValuationsBranch.find_by(catalog_branch_id: cedis_de_carga.id, valuation_id: valuation.valuation.id)
                        puts "********************************** tasa_costo 2: #{tasa_costo}"        
                        if tasa_costo
                            hash_asientoDeDiario["numeroCuenta"] = tasa_costo.valuation.cuenta
                        else
                            @mensaje_error  = ["El cedis: #{cedis_de_carga.decripcion} no tiene asignada la tasa correspondiente al iva de la factura."]
                            return [@mensaje_error,false]
                        end
                    else
                        account_impact = AccountingImpact.find_by(catalog_branch_id: self.catalog_branch_id,  cuenta_contable: "Otros gastos",catalog_area_id:catalogo.id,status:true)#.select(:nombre)#    "01060102.6103.0101"
                        if account_impact == nil
                            @mensaje_error  = ["No se encontró el Numero de cuenta para el cedis: #{self.catalog_branch.decripcion} y área: #{catalogo.descripcion} para el concepto de combustible otros gastos, por favor revise la información. Folio: #{self.folio}"]
                            return [@mensaje_error,false] 
                        else
                            hash_asientoDeDiario["numeroCuenta"] = account_impact.nombre
                        end
                    end
                else
                    #@mensaje_error  = ["No se encontró el Numero de cuenta para el cedis: #{self.catalog_branch.decripcion} y área: #{catalogo.descripcion} para el concepto de combustible, por favor revise la información. Folio: #{self.folio}"]
                    @mensaje_error  = ["El cedis: #{self.catalog_branch.decripcion} no tiene asignada la tasa correspondiente al iva de la factura."]
                    return [@mensaje_error,false]
                end
                
                # account_impact = AccountingImpact.find_by(catalog_branch_id: self.catalog_branch_id,  cuenta_contable: "Combustible",catalog_area_id:catalogo.id,status:true)#.select(:nombre)#    "01060102.6103.0101"
                # if account_impact == nil
                #     @mensaje_error  = ["No se encontró el Numero de cuenta para el cedis: #{self.catalog_branch.decripcion} y área: #{catalogo.descripcion} para el concepto de combustible, por favor revise la información. Folio: #{self.folio}"]
                #     return [@mensaje_error,false] 
                # end
                # #aun no esta
                # if account_impact.present?
                #     if ac.cedisorigen == ac.cediscarga
                #         hash_asientoDeDiario["numeroCuenta"] = account_impact.nombre
                #     else
                #         account_impact = AccountingImpact.find_by(catalog_branch_id: self.catalog_branch_id,  cuenta_contable: "Otros gastos",catalog_area_id:catalogo.id,status:true)#.select(:nombre)#    "01060102.6103.0101"
                #         if account_impact == nil
                #             @mensaje_error  = ["No se encontró el Numero de cuenta para el cedis: #{self.catalog_branch.decripcion} y área: #{catalogo.descripcion} para el concepto de combustible otros gastos, por favor revise la información. Folio: #{self.folio}"]
                #             return [@mensaje_error,false] 
                #         else
                #             hash_asientoDeDiario["numeroCuenta"] = account_impact.nombre
                #         end
                #     end
                # else
                #     hash_asientoDeDiario["numeroCuenta"] = ""
                # end
                #------------------------------------------------------------------------------------
                #no se si esta bien estos campos
                hash_asientoDeDiario["modoDeCuenta"] = "2"
                hash_asientoDeDiario["subledger"] = self.catalog_vendor.clave
                hash_asientoDeDiario["subledgerType"] = "A"
                #---------------------------------------------------------------------------------------
                hash_asientoDeDiario["tipoLibro"] = "AA"
                hash_asientoDeDiario["periodoFiscal"] = "0"
                #hash_asientoDeDiario["sigloFiscal"] = "21"
                hash_asientoDeDiario["sigloFiscal"] = "20"
                hash_asientoDeDiario["añoFiscal"] = "0"
                hash_asientoDeDiario["moneda"] = "MXP"
                #monto_total = @costos.map{|x| x.monto}.inject(:+)
                #impuestos_total = @costos.map{|x| x.impuestos}.inject(:+)
                if self.es_detallado
                    bandera_impuesto = (ac.impuestos.to_f.round(2) / valor_iva).round(2)
                    if ((ac.monto.to_f - ac.impuestos) - bandera_impuesto) > 0
                        bandera_base_cero = true
                    end
                    #byebug
                    if bandera_base_cero == true
                        monto_total = (ac.impuestos.ceil(2) / valor_iva).ceil(2)
                        impuestos_total = ac.impuestos.to_f

                        impuesto_base_renglon = ac.impuestos.to_f
                        monto_base_renglon = ac.monto.to_f
                        impuesto_base_cero_renglon = ac.monto - monto_total
                        #if index == 0
                        #end
                        #impuestos_totales = impuestos_totales + ac.impuestos.to_f 
                        impuesto_base_cero = ((ac.monto.ceil(2) - ac.impuestos.ceil(2)) - monto_total).ceil(2)
                        imponible = monto_total.to_f
                        #byebug
                        #valor_diario_monto = (imponible.ceil(2)*100).ceil
                        valor_diario_monto = (((imponible.ceil(2) + impuesto_base_cero.ceil(2)).ceil(2)*100).ceil(2)).to_i
                        #byebug
                        acumulado_impuesto_base_cero += (impuesto_base_cero.round(2)*100).round
                        acumulado_monto_total_base_cero += (monto_total.round(2)*100).round
                        acumulado_imponible_base_cero += (valor_diario_monto.round(2)).round
                    else
                        monto_total = ac.monto.to_f
                        impuestos_total = ac.impuestos.to_f
                        #impuestos_totales = impuestos_totales + ac.impuestos.to_f 
                        imponible = (monto_total.to_f - impuestos_total.to_f)
                        valor_diario_monto = (((imponible.round(2)*100).round(2)).to_f).to_s
                        acumulado_impuesto += (impuestos_total.round(2)*100).round
                        acumulado_monto_total += (monto_total.round(2)*100).round
                        acumulado_imponible += (valor_diario_monto.round(2)).round
                    end
                else

                    division_mto_fact = (ac.monto / self.monto).round(2)
                    #base_cero_imp = self.impuestos.to_f.floor(2) / valor_iva

                    prorrat_imp = (division_mto_fact * self.impuestos).round(2)

                    bandera_impuesto = (self.impuestos.to_f.round(2) / valor_iva).round(2)

                    bandera_impuesto_renglon = prorrat_imp / valor_iva

                    prorrat_base_cero = (division_mto_fact * ((self.monto - self.impuestos) - bandera_impuesto))


                    if ((ac.monto.to_f - prorrat_imp) - bandera_impuesto) > 0
                        bandera_base_cero = true
                    end
                    #byebug
                    if bandera_base_cero == true
                        #prorrat_imp_linea = self.impuestos * (division_mto_fact)
                        monto_total = ac.monto - prorrat_imp
                        impuestos_total = prorrat_imp.to_f

                        impuesto_base_renglon = prorrat_imp.to_f
                        monto_base_renglon = prorrat_imp.to_f
                        impuesto_base_cero_renglon = prorrat_base_cero

                        impuesto_base_cero = prorrat_base_cero

                        imponible = monto_total.to_f

                        valor_diario_monto = ((imponible.round(2))*100).round
                        #byebug
                        acumulado_impuesto_base_cero += (impuesto_base_cero.round(2)*100).round
                        acumulado_monto_total_base_cero += (monto_total.round(2)*100).round
                        acumulado_imponible_base_cero += (valor_diario_monto.round(2)).round
                    else
                        monto_total = ac.monto - prorrat_imp
                        impuestos_total = prorrat_imp.to_f

                        #imponible = (monto_total.to_f - impuestos_total.to_f)
                        valor_diario_monto = (monto_total.round(2)*100).round
                        acumulado_impuesto += (impuestos_total.round(2)*100).round
                        acumulado_monto_total += (monto_total.round(2)*100).round
                        acumulado_imponible += (valor_diario_monto.round(2)).round
                    end
                end
                # imponible = (self.monto/1.16).round(2)
                #     if index == 0
                # valor_div = (valor_diario_monto.to_f/100)/(imponible_global.to_f/100).round(4)
                # valor_mult = (valor_div * base.round(2)).round(2)
                # monto_base = ((valor_diario_monto.to_f/100) - valor_mult).round(2)
                # hash_asientoDeDiario["monto"]  = (monto_base * 100).to_i
                #byebug
                    if (@costos.length - 1) == index
                        #monto_total = @costos.map{|x| x.monto}.inject(:+)
                        #byebug
                        if @asientoDeDiario.length > 0 
                            valor_bandera = valor_diario_monto + @asientoDeDiario.map{|x| x["monto"]}.inject(:+)
                        else
                            valor_bandera = valor_diario_monto
                        end
                        if bandera_base_cero == true
                            #byebug
                            resta_diario_monto =  ((((self.impuestos / valor_iva).round(2) * 100).round(2) + importes) - valor_bandera).to_f
                        else
                            resta_diario_monto = ((((self.impuestos / valor_iva).round(2) * 100).round(2)) - valor_bandera).to_f
                        end
                        if resta_diario_monto == 1
                            hash_asientoDeDiario["monto"] = valor_diario_monto + 1
                        elsif resta_diario_monto == -1 
                            hash_asientoDeDiario["monto"] = valor_diario_monto - 1
                        else
                            hash_asientoDeDiario["monto"] = valor_diario_monto
                        end
                    else
                        hash_asientoDeDiario["monto"] = valor_diario_monto
                    end
                    #  (imponible * 100).to_i #((self.monto * 0.8654)*100).to_i
                #     else
                #     hash_asientoDeDiario["monto"] = ((imponible * 0.16).round(2) *100).to_i#((self.monto - (self.monto * 0.8654))*100).to_i
                #     end

                hash_asientoDeDiario["explicacion"] = self.catalog_vendor.razonsocial.first(30) #"Servicios Gasolineros de Mexic"# //eeee
                if ac.cedisorigen == ac.cediscarga
                    hash_asientoDeDiario["observaciones"] = "#{self.catalog_branch.abreviacion} COMB #{self.fecha_inicio.strftime("%d")}-#{self.fecha_fin.strftime("%d")} #{ I18n.l(self.fecha_fin, format: '%B')}" # cambiar las 3 primeras letras del cedis comb se queda
                else
                    hash_asientoDeDiario["observaciones"] = "#{self.catalog_branch.catalog_company.abreviatura} #{self.catalog_branch.abreviacion} COMB #{self.fecha_inicio.strftime("%d")}-#{self.fecha_fin.strftime("%d")} #{ I18n.l(self.fecha_fin, format: '%B')}" # cambiar las 3 primeras letras del cedis comb se queda
                end
                hash_asientoDeDiario["numeroBeneficiario"] = self.catalog_vendor.clave # self.vehicle_consumptions[0].vehicle.catalog_company.clave
                #aun no esta
                hash_asientoDeDiario["factura"] = self.n_factura #""#"145525"
                #----------------------------------

                hash_asientoDeDiario["fechaFactura"] = "1#{self.fecha_fin.strftime("%y")}#{(self.fecha_fin).strftime("%j")}"
                hash_asientoDeDiario["fechaEfectiva"] = "1#{self.created_at.strftime("%y")}#{(self.created_at).strftime("%j")}"
                hash_asientoDeDiario["codigoMoneda"] = "D"
                hash_asientoDeDiario["originador"] = @current_user.correo_combustibles #sacar de usuario de correo verificar que sea gafi.com.mx si no DYENCALADA 
                hash_asientoDeDiario["usuarioActualizacion"] = @current_user.correo_combustibles #sacar de usuario de correo verificar que sea gafi.com.mx si no DYENCALADA 
                hash_asientoDeDiario["idPrograma"] = self.id
                hash_asientoDeDiario["fechaActualizacion"] = "1#{Time.zone.now.strftime("%y")}#{(Time.zone.now).strftime("%j")}"
                hash_asientoDeDiario["horaActualizacion"] = Time.zone.now.strftime("%H%M%S")
                hash_asientoDeDiario["estacionDeTrabajo"]  = "WEB91a"
                @asientoDeDiario <<hash_asientoDeDiario
                #byebug
            #end
        end



        hash_info_adicional["UUID"] = self.uuid
        @info_adicional << hash_info_adicional
        hash_polizaInput["asientoDeDiario"] = @asientoDeDiario
        hash_polizaInput["infoAdicional"] = @info_adicional
        @polizaInput << hash_polizaInput
        hash_principal["polizaInput"] = @polizaInput[0]
        @objeto_principal << hash_principal
        # comentar de aquí a...
        paremetro_nombre = Parameter.find_by(nombre:"Url Poliza JDE")
        url = URI(paremetro_nombre.valor_extendido)
        https = Net::HTTP.new(url.host, url.port);
        request = Net::HTTP::Put.new(url)
        request["Content-Type"] = "application/json"
        request["Accept"] = "application/json"
        request.body = @objeto_principal[0].to_json
        response = https.request(request)
        @json_parciado = []
        respuesta = JSON.parse response.body
        if respuesta[0].nil?
            @json_parciado.push(respuesta)
        else
            @json_parciado = respuesta
        end
        #byebug
        JdeLog.create(
            fecha: Time.zone.now.to_date,
            hora: Time.zone.now,
            json_enviado: @objeto_principal,
            respuesta: @json_parciado
        )
            
        if @json_parciado.map{|x| x['Exitoso']}.include?(false) 
            enviar_json_redondeado(@current_user)
            #return [@json_parciado,false]
        else
            return [@json_parciado,true]
        end

        

        # aquí, para no  enviar  el json a JDE
        #return[@objeto_principal,true]   #descomentar este return para que ver el json que se esta mandando a JDE
    end
        
    def self.monto_semana(con)
        return self.where(semana: con.semana,estatus:[1,2], catalog_branch_id: con.catalog_branch_id, catalog_vendor_id: con.catalog_vendor_id, fecha_inicio: con.fecha_inicio, fecha_fin: con.fecha_fin).sum(:monto)
    end


    def self.cargas_semana(con)
        return self.where(semana: con.semana,estatus:[1,2], catalog_branch_id: con.catalog_branch_id, catalog_vendor_id: con.catalog_vendor_id, fecha_inicio: con.fecha_inicio, fecha_fin: con.fecha_fin).sum(:cargas)
      end

      def self.litros_consumoDetalle(fecha_inicio,fecha_fin,cedis,vendor)
        arreglo_litros = Array.new()
        #byebug
        ventas = VehicleConsumption.joins(:consumption).joins(:vehicle).where(consumptions: {catalog_branch_id: cedis,catalog_vendor_id:vendor},vehicle_id: Vehicle.where(catalog_area_id: CatalogArea.find_by(descripcion: "Ventas")),fecha: fecha_inicio..fecha_fin)

        ventas.each do |i|
            hash_litros = Hash.new
            cualquiera = arreglo_litros.find {|item| item["no_economico"] == "#{i.vehicle.numero_economico}"}
            #byebug
            if cualquiera.nil?
                hash_litros["no_economico"] = i.vehicle.numero_economico
                hash_litros["cantidad"] =  i.cantidad
                hash_litros["rendimiento"] = i.rendimiento
                hash_litros["cantidad_cargas"] = 1
                hash_litros["promedio"] = 100
                hash_litros["monto"] = i.monto
                hash_litros["base"] = 100
                i.consumption.n_factura ? hash_litros["factura"] = i.consumption.n_factura : hash_litros["factura"] = "No se asignó una factura." 
                i.vehicle.catalog_area ? hash_litros["area"] = i.vehicle.catalog_area.descripcion : hash_litros["area"] = "No se asignó"
                i.vehicle ? hash_litros["vehiculo"] = i.vehicle.numero_economico : hash_litros["vehiculo"] = "No se asignó"
                i.vehicle.catalog_personal ? hash_litros["personal"] = i.vehicle.catalog_personal.nombre : hash_litros["personal"] = "No se asignó"                
                arreglo_litros.push(hash_litros)
                #byebug
            else
                valor_anterior = cualquiera["cantidad"]
                valor_nuevo = valor_anterior + i.cantidad
                cualquiera["cantidad"] = valor_nuevo
                cantidad_cargas = cualquiera["cantidad_cargas"]
                cantidad_nueva = cantidad_cargas + 1
                cualquiera["cantidad_cargas"] = cantidad_nueva
                rendimiento_anterior = cualquiera["rendimiento"]
                rendimiento_nuevo = rendimiento_anterior + i.rendimiento
                cualquiera["rendimiento"] = rendimiento_nuevo
                cualquiera["promedio"] =  rendimiento_nuevo / cantidad_nueva 
                monto_anterior = cualquiera["monto"]
                monto_nuevo = monto_anterior + i.monto
                cualquiera["monto"] = monto_nuevo
                base = cualquiera["base"]
                cualquiera["base"] = (cualquiera["monto"] * 0.8654)
            end
        end
        #byebug
        return arreglo_litros
    end

    def self.litros_adminDetalle(fecha_inicio,fecha_fin,cedis,vendor)
        arreglo_litros = Array.new()
        #byebug
        admin = VehicleConsumption.joins(:consumption).joins(:vehicle).where(consumptions: {catalog_branch_id: cedis,catalog_vendor_id:vendor},vehicle_id: Vehicle.where(catalog_area_id: CatalogArea.find_by(descripcion: "Administración")),fecha: fecha_inicio..fecha_fin)

        admin.each do |i|
            hash_litros = Hash.new
            cualquiera = arreglo_litros.find {|item| item["no_economico"] == "#{i.vehicle.numero_economico}"}
            #byebug
            if cualquiera.nil?
                hash_litros["no_economico"] = i.vehicle.numero_economico
                hash_litros["cantidad"] = i.cantidad
                hash_litros["rendimiento"] = i.rendimiento
                hash_litros["cantidad_cargas"] = 1
                hash_litros["promedio"] = 100
                hash_litros["monto"] = i.monto
                hash_litros["base"] = 100
                i.consumption.n_factura ? hash_litros["factura"] = i.consumption.n_factura : hash_litros["factura"] = "No se asignó una factura." 
                i.vehicle.catalog_area ? hash_litros["area"] = i.vehicle.catalog_area.descripcion : hash_litros["area"] = "No se asignó"
                i.vehicle ? hash_litros["vehiculo"] = i.vehicle.numero_economico : hash_litros["vehiculo"] = "No se asignó"
                i.vehicle.catalog_personal ? hash_litros["personal"] = i.vehicle.catalog_personal.nombre : hash_litros["personal"] = "No se asignó"  
                arreglo_litros.push(hash_litros)
                #byebug
            else
                valor_anterior = cualquiera["cantidad"]
                valor_nuevo = valor_anterior + i.cantidad
                cualquiera["cantidad"] = valor_nuevo
                cantidad_cargas = cualquiera["cantidad_cargas"]
                cantidad_nueva = cantidad_cargas + 1
                cualquiera["cantidad_cargas"] = cantidad_nueva
                rendimiento_anterior = cualquiera["rendimiento"]
                rendimiento_nuevo = rendimiento_anterior + i.rendimiento
                cualquiera["rendimiento"] = rendimiento_nuevo
                cualquiera["promedio"] =  rendimiento_nuevo / cantidad_nueva 
                monto_anterior = cualquiera["monto"]
                monto_nuevo = monto_anterior + i.monto
                cualquiera["monto"] = monto_nuevo
                base = cualquiera["base"]
                cualquiera["base"] = (cualquiera["monto"] * 0.8654)
            end
        end
        #byebug
        return arreglo_litros
    end

    def self.litros_almacenDetalle(fecha_inicio,fecha_fin,cedis,vendor)
        arreglo_litros = Array.new()
        #byebug
        almacen = VehicleConsumption.joins(:consumption).joins(:vehicle).where(consumptions: {catalog_branch_id: cedis,catalog_vendor_id:vendor},vehicle_id: Vehicle.where(catalog_area_id: CatalogArea.find_by(descripcion: "Operaciones")),fecha: fecha_inicio..fecha_fin)
        #byebug
        almacen.each do |i|
            hash_litros = Hash.new
            cualquiera = arreglo_litros.find {|item| item["no_economico"] == "#{i.vehicle.numero_economico}"}
            #byebug
            if cualquiera.nil?
                hash_litros["no_economico"] = i.vehicle.numero_economico
                hash_litros["cantidad"] = i.cantidad
                hash_litros["rendimiento"] = i.rendimiento
                hash_litros["cantidad_cargas"] = 1
                hash_litros["promedio"] = 100
                hash_litros["monto"] = i.monto
                hash_litros["base"] = 100
                i.consumption.n_factura ? hash_litros["factura"] = i.consumption.n_factura : hash_litros["factura"] = "No se asignó una factura." 
                i.vehicle.catalog_area ? hash_litros["area"] = i.vehicle.catalog_area.descripcion : hash_litros["area"] = "No se asignó"
                i.vehicle ? hash_litros["vehiculo"] = i.vehicle.numero_economico : hash_litros["vehiculo"] = "No se asignó"
                i.vehicle.catalog_personal ? hash_litros["personal"] = i.vehicle.catalog_personal.nombre : hash_litros["personal"] = "No se asignó"  
                arreglo_litros.push(hash_litros)
                #byebug
            else
                valor_anterior = cualquiera["cantidad"]
                valor_nuevo = valor_anterior + i.cantidad
                cualquiera["cantidad"] = valor_nuevo
                cantidad_cargas = cualquiera["cantidad_cargas"]
                cantidad_nueva = cantidad_cargas + 1
                cualquiera["cantidad_cargas"] = cantidad_nueva
                rendimiento_anterior = cualquiera["rendimiento"]
                rendimiento_nuevo = rendimiento_anterior + i.rendimiento
                cualquiera["rendimiento"] = rendimiento_nuevo
                cualquiera["promedio"] =  rendimiento_nuevo / cantidad_nueva 
                monto_anterior = cualquiera["monto"]
                monto_nuevo = monto_anterior + i.monto
                cualquiera["monto"] = monto_nuevo
                base = cualquiera["base"]
                cualquiera["base"] = (cualquiera["monto"] * 0.8654)
            end
        end
        #byebug
        return arreglo_litros
    end


    def self.busqueda_solicitud(fecha_inicio, fecha_fin,cedis)
        if fecha_inicio != "" and fecha_fin != "" and cedis != ""
            self.joins(:catalog_branch).por_cedis(cedis).por_fecha_inicio(fecha_inicio.to_date).por_fecha_fin(fecha_fin.to_date).where(estatus: "Autorizado")
        elsif fecha_inicio == "" and fecha_fin != "" and cedis != ""
            self.joins(:catalog_branch).por_cedis(cedis).por_fecha_fin(fecha_fin.to_date).where(estatus: "Autorizado")
        elsif fecha_inicio != "" and fecha_fin == "" and cedis != ""
            self.joins(:catalog_branch).por_cedis(cedis).por_fecha_inicio(fecha_inicio.to_date).where(estatus:"Autorizado")
        elsif fecha_inicio == "" and fecha_fin == "" and cedis != ""
            self.joins(:catalog_branch).por_cedis(cedis).where(estatus:"Autorizado")
        end
    end
    
    def self.consulta_cargas(fecha_ini,fecha_fin,proveedor,cedis,estatus)
        cadena_consulta = ""
        fecha_hora = (Time.now - 1.year).strftime("%Y-%m-%d %H:%M:%M")
        #fecha_hora = (Time.now + 7.hours).strftime("%Y-%m-%d %H:%M:%M")
		if estatus != "" or estatus.nil?
			cadena_consulta += " estatus = #{estatus} and"
		end

        if proveedor != ""
            cadena_consulta += " catalog_vendor_id = #{proveedor} and"
        end

        if cedis != ""
            cadena_consulta += " catalog_branch_id = #{cedis} and"
        end

        if fecha_ini != "" and fecha_fin != ""
            cadena_consulta += " fecha_inicio >= '#{(fecha_ini).strftime("%Y-%m-%d")}' and fecha_fin <= '#{(fecha_fin).strftime("%Y-%m-%d")}'"
        else
            cadena_consulta += " created_at <= '#{fecha_hora}'"
        end
		consulta = Consumption.where(cadena_consulta).where.not(estatus:2).order(created_at: :desc)
		return consulta  
    end


    def self.litros_consumo(fecha_inicio,fecha_fin,cedis,vendor, encabezado)
        arreglo_litros = Array.new()
        #byebug
        #ventas = encabezado.vehicle_consumptions.where(vehicle_id: Vehicle.where(catalog_area_id: CatalogArea.find_by(descripcion: "Ventas").id).ids)
        ventas = VehicleConsumption.joins(:consumption).joins(:vehicle).where(consumptions: {catalog_branch_id: cedis,catalog_vendor_id:vendor},vehicle_id: Vehicle.where(catalog_area_id: CatalogArea.find_by(descripcion: "Ventas")),fecha: fecha_inicio..fecha_fin)
        #byebug
        ventas.each do |i|
            hash_litros = Hash.new
            cualquiera = arreglo_litros.find {|item| item["no_economico"] == "#{i.vehicle.numero_economico}"}
            #byebug
            if cualquiera.nil?
                hash_litros["no_economico"] = i.vehicle.numero_economico
                hash_litros["tipo_vehiculo"] = "#{i.vehicle.catalog_brand.descripcion} #{i.vehicle.catalog_model.descripcion}"
                hash_litros["cantidad"] = i.cantidad
                hash_litros["rendimiento"] = i.rendimiento
                hash_litros["cantidad_cargas"] = 1
                hash_litros["promedio"] = 100
                hash_litros["monto"] = i.monto
                hash_litros["base"] = 100
                i.consumption.n_factura ? hash_litros["factura"] = i.consumption.n_factura : hash_litros["factura"] = "No se asignó una factura." 
                i.vehicle.catalog_area ? hash_litros["area"] = i.vehicle.catalog_area.descripcion : hash_litros["area"] = "No se asignó"
                i.vehicle ? hash_litros["vehiculo"] = i.vehicle.numero_economico : hash_litros["vehiculo"] = "No se asignó"
                i.vehicle.catalog_personal ? hash_litros["personal"] = i.vehicle.catalog_personal.nombre : hash_litros["personal"] = "No se asignó"                
                arreglo_litros.push(hash_litros)
                #byebug
            else
                valor_anterior = cualquiera["cantidad"]
                valor_nuevo = valor_anterior + i.cantidad
                cualquiera["cantidad"] = valor_nuevo
                cantidad_cargas = cualquiera["cantidad_cargas"]
                cantidad_nueva = cantidad_cargas + 1
                cualquiera["cantidad_cargas"] = cantidad_nueva
                rendimiento_anterior = cualquiera["rendimiento"]
                rendimiento_nuevo = rendimiento_anterior + i.rendimiento
                cualquiera["rendimiento"] = rendimiento_nuevo
                cualquiera["promedio"] =  rendimiento_nuevo / cantidad_nueva 
                monto_anterior = cualquiera["monto"]
                monto_nuevo = monto_anterior + i.monto
                cualquiera["monto"] = monto_nuevo
                base = cualquiera["base"]
                cualquiera["base"] = (cualquiera["monto"] * 0.8654)
            end
        end
        #byebug
        return arreglo_litros
    end

    def self.litros_admin(fecha_inicio,fecha_fin,cedis,vendor)
        arreglo_litros = Array.new()
        #byebug
        admin = VehicleConsumption.joins(:consumption).joins(:vehicle).where(consumptions: {catalog_branch_id: cedis,catalog_vendor_id:vendor},vehicle_id: Vehicle.where(catalog_area_id: CatalogArea.find_by(descripcion: "Administrativo")),fecha: fecha_inicio..fecha_fin)
        #byebug
        admin.each do |i|
            hash_litros = Hash.new
            cualquiera = arreglo_litros.find {|item| item["no_economico"] == "#{i.vehicle.numero_economico}"}
            #byebug
            if cualquiera.nil?
                hash_litros["no_economico"] = i.vehicle.numero_economico
                hash_litros["tipo_vehiculo"] = "#{i.vehicle.catalog_brand.descripcion} #{i.vehicle.catalog_model.descripcion}"
                hash_litros["cantidad"] = i.cantidad
                hash_litros["rendimiento"] = i.rendimiento
                hash_litros["cantidad_cargas"] = 1
                hash_litros["promedio"] = 100
                hash_litros["monto"] = i.monto
                hash_litros["base"] = 100
                i.consumption.n_factura ? hash_litros["factura"] = i.consumption.n_factura : hash_litros["factura"] = "No se asignó una factura." 
                i.vehicle.catalog_area ? hash_litros["area"] = i.vehicle.catalog_area.descripcion : hash_litros["area"] = "No se asignó"
                i.vehicle ? hash_litros["vehiculo"] = i.vehicle.numero_economico : hash_litros["vehiculo"] = "No se asignó"
                i.vehicle.catalog_personal ? hash_litros["personal"] = i.vehicle.catalog_personal.nombre : hash_litros["personal"] = "No se asignó"  
                arreglo_litros.push(hash_litros)
                #byebug
            else
                valor_anterior = cualquiera["cantidad"]
                valor_nuevo = valor_anterior + i.cantidad
                cualquiera["cantidad"] = valor_nuevo
                cantidad_cargas = cualquiera["cantidad_cargas"]
                cantidad_nueva = cantidad_cargas + 1
                cualquiera["cantidad_cargas"] = cantidad_nueva
                rendimiento_anterior = cualquiera["rendimiento"]
                rendimiento_nuevo = rendimiento_anterior + i.rendimiento
                cualquiera["rendimiento"] = rendimiento_nuevo
                cualquiera["promedio"] =  rendimiento_nuevo / cantidad_nueva 
                monto_anterior = cualquiera["monto"]
                monto_nuevo = monto_anterior + i.monto
                cualquiera["monto"] = monto_nuevo
                base = cualquiera["base"]
                cualquiera["base"] = (cualquiera["monto"] * 0.8654)
            end
        end
        #byebug
        return arreglo_litros
    end

    def self.litros_almacen(fecha_inicio,fecha_fin,cedis,vendor)
        arreglo_litros = Array.new()
        #byebug
        
        almacen = VehicleConsumption.joins(:consumption).joins(:vehicle).where(consumptions: {catalog_branch_id: cedis,catalog_vendor_id:vendor},vehicle_id: Vehicle.where(catalog_area_id: CatalogArea.find_by(descripcion: "Almacén")),fecha: fecha_inicio..fecha_fin)
        #byebug
        almacen.each do |i|
            hash_litros = Hash.new
            cualquiera = arreglo_litros.find {|item| item["no_economico"] == "#{i.vehicle.numero_economico}"}
            #byebug
            if cualquiera.nil?
                hash_litros["no_economico"] = i.vehicle.numero_economico
                hash_litros["tipo_vehiculo"] = "#{i.vehicle.catalog_brand.descripcion} #{i.vehicle.catalog_model.descripcion}"
                hash_litros["cantidad"] = i.cantidad
                hash_litros["rendimiento"] = i.rendimiento
                hash_litros["cantidad_cargas"] = 1
                hash_litros["promedio"] = 100
                hash_litros["monto"] = i.monto
                hash_litros["base"] = 100
                i.consumption.n_factura ? hash_litros["factura"] = i.consumption.n_factura : hash_litros["factura"] = "No se asignó una factura." 
                i.vehicle.catalog_area ? hash_litros["area"] = i.vehicle.catalog_area.descripcion : hash_litros["area"] = "No se asignó"
                i.vehicle ? hash_litros["vehiculo"] = i.vehicle.numero_economico : hash_litros["vehiculo"] = "No se asignó"
                i.vehicle.catalog_personal ? hash_litros["personal"] = i.vehicle.catalog_personal.nombre : hash_litros["personal"] = "No se asignó"  
                arreglo_litros.push(hash_litros)
                #byebug
            else
                valor_anterior = cualquiera["cantidad"]
                valor_nuevo = valor_anterior + i.cantidad
                cualquiera["cantidad"] = valor_nuevo
                cantidad_cargas = cualquiera["cantidad_cargas"]
                cantidad_nueva = cantidad_cargas + 1
                cualquiera["cantidad_cargas"] = cantidad_nueva
                rendimiento_anterior = cualquiera["rendimiento"]
                rendimiento_nuevo = rendimiento_anterior + i.rendimiento
                cualquiera["rendimiento"] = rendimiento_nuevo
                cualquiera["promedio"] =  rendimiento_nuevo / cantidad_nueva 
                monto_anterior = cualquiera["monto"]
                monto_nuevo = monto_anterior + i.monto
                cualquiera["monto"] = monto_nuevo
                base = cualquiera["base"]
                cualquiera["base"] = (cualquiera["monto"] * 0.8654)
            end
        end
        #byebug
        return arreglo_litros
    end

# ---------------------------- consumos con iva --------------------------------

    def self.litros_consumo8(fecha_inicio,fecha_fin,cedis,vendor, encabezado)
        arreglo_litros = Array.new()
        #byebug
        #ventas = encabezado.vehicle_consumptions.where(vehicle_id: Vehicle.where(catalog_area_id: CatalogArea.find_by(descripcion: "Ventas").id).ids)
        valuation = Valuation.find_by(tipo_zona: "IVA8GAS", estatus: true)
        ventas = VehicleConsumption.joins(:consumption).joins(:vehicle).where(consumptions: {catalog_branch_id: cedis,catalog_vendor_id:vendor, valuation_id: valuation.id},vehicle_id: Vehicle.where(catalog_area_id: CatalogArea.find_by(descripcion: "Ventas")),fecha: fecha_inicio..fecha_fin)
        #byebug
        ventas.each do |i|
            hash_litros = Hash.new
            cualquiera = arreglo_litros.find {|item| item["no_economico"] == "#{i.vehicle.numero_economico}"}
            #byebug
            if cualquiera.nil?
                hash_litros["no_economico"] = i.vehicle.numero_economico
                hash_litros["tipo_vehiculo"] = "#{i.vehicle.catalog_brand.descripcion} #{i.vehicle.catalog_model.descripcion}"
                hash_litros["empresa"] = i.vehicle.catalog_company.nombre
                hash_litros["cantidad"] = i.cantidad
                hash_litros["rendimiento"] = i.rendimiento
                hash_litros["cantidad_cargas"] = 1
                hash_litros["promedio"] = 100
                hash_litros["monto"] = i.monto
                hash_litros["base"] = 100
                i.consumption.n_factura ? hash_litros["factura"] = i.consumption.n_factura : hash_litros["factura"] = "No se asignó una factura." 
                i.vehicle.catalog_area ? hash_litros["area"] = i.vehicle.catalog_area.descripcion : hash_litros["area"] = "No se asignó"
                i.vehicle ? hash_litros["vehiculo"] = i.vehicle.numero_economico : hash_litros["vehiculo"] = "No se asignó"
                i.vehicle.catalog_personal ? hash_litros["personal"] = i.vehicle.catalog_personal.nombre : hash_litros["personal"] = "No se asignó"                
                arreglo_litros.push(hash_litros)
                #byebug
            else
                valor_anterior = cualquiera["cantidad"]
                valor_nuevo = valor_anterior + i.cantidad
                cualquiera["cantidad"] = valor_nuevo
                cantidad_cargas = cualquiera["cantidad_cargas"]
                cantidad_nueva = cantidad_cargas + 1
                cualquiera["cantidad_cargas"] = cantidad_nueva
                rendimiento_anterior = cualquiera["rendimiento"]
                rendimiento_nuevo = rendimiento_anterior + i.rendimiento
                cualquiera["rendimiento"] = rendimiento_nuevo
                cualquiera["promedio"] =  rendimiento_nuevo / cantidad_nueva 
                monto_anterior = cualquiera["monto"]
                monto_nuevo = monto_anterior + i.monto
                cualquiera["monto"] = monto_nuevo
                base = cualquiera["base"]
                cualquiera["base"] = (cualquiera["monto"] * 0.8654)
            end
        end
        #byebug
        return arreglo_litros
    end

    def self.litros_admin8(fecha_inicio,fecha_fin,cedis,vendor)
        arreglo_litros = Array.new()
        #byebug
        valuation = Valuation.find_by(tipo_zona: "IVA8GAS", estatus: true)
        admin = VehicleConsumption.joins(:consumption).joins(:vehicle).where(consumptions: {catalog_branch_id: cedis,catalog_vendor_id:vendor, valuation_id: valuation.id},vehicle_id: Vehicle.where(catalog_area_id: CatalogArea.find_by(descripcion: "Administrativo")),fecha: fecha_inicio..fecha_fin)
        #byebug
        admin.each do |i|
            hash_litros = Hash.new
            cualquiera = arreglo_litros.find {|item| item["no_economico"] == "#{i.vehicle.numero_economico}"}
            #byebug
            if cualquiera.nil?
                hash_litros["no_economico"] = i.vehicle.numero_economico
                hash_litros["tipo_vehiculo"] = "#{i.vehicle.catalog_brand.descripcion} #{i.vehicle.catalog_model.descripcion}"
                hash_litros["empresa"] = i.vehicle.catalog_company.nombre
                hash_litros["cantidad"] = i.cantidad
                hash_litros["rendimiento"] = i.rendimiento
                hash_litros["cantidad_cargas"] = 1
                hash_litros["promedio"] = 100
                hash_litros["monto"] = i.monto
                hash_litros["base"] = 100
                i.consumption.n_factura ? hash_litros["factura"] = i.consumption.n_factura : hash_litros["factura"] = "No se asignó una factura." 
                i.vehicle.catalog_area ? hash_litros["area"] = i.vehicle.catalog_area.descripcion : hash_litros["area"] = "No se asignó"
                i.vehicle ? hash_litros["vehiculo"] = i.vehicle.numero_economico : hash_litros["vehiculo"] = "No se asignó"
                i.vehicle.catalog_personal ? hash_litros["personal"] = i.vehicle.catalog_personal.nombre : hash_litros["personal"] = "No se asignó"  
                arreglo_litros.push(hash_litros)
                #byebug
            else
                valor_anterior = cualquiera["cantidad"]
                valor_nuevo = valor_anterior + i.cantidad
                cualquiera["cantidad"] = valor_nuevo
                cantidad_cargas = cualquiera["cantidad_cargas"]
                cantidad_nueva = cantidad_cargas + 1
                cualquiera["cantidad_cargas"] = cantidad_nueva
                rendimiento_anterior = cualquiera["rendimiento"]
                rendimiento_nuevo = rendimiento_anterior + i.rendimiento
                cualquiera["rendimiento"] = rendimiento_nuevo
                cualquiera["promedio"] =  rendimiento_nuevo / cantidad_nueva 
                monto_anterior = cualquiera["monto"]
                monto_nuevo = monto_anterior + i.monto
                cualquiera["monto"] = monto_nuevo
                base = cualquiera["base"]
                cualquiera["base"] = (cualquiera["monto"] * 0.8654)
            end
        end
        #byebug
        return arreglo_litros
    end

    def self.litros_almacen8(fecha_inicio,fecha_fin,cedis,vendor)
        arreglo_litros = Array.new()
        #byebug
        
        valuation = Valuation.find_by(tipo_zona: "IVA8GAS", estatus: true)
        almacen = VehicleConsumption.joins(:consumption).joins(:vehicle).where(consumptions: {catalog_branch_id: cedis,catalog_vendor_id:vendor, valuation_id: valuation.id},vehicle_id: Vehicle.where(catalog_area_id: CatalogArea.find_by(descripcion: "Almacén")),fecha: fecha_inicio..fecha_fin)
        #byebug
        almacen.each do |i|
            hash_litros = Hash.new
            cualquiera = arreglo_litros.find {|item| item["no_economico"] == "#{i.vehicle.numero_economico}"}
            #byebug
            if cualquiera.nil?
                hash_litros["no_economico"] = i.vehicle.numero_economico
                hash_litros["tipo_vehiculo"] = "#{i.vehicle.catalog_brand.descripcion} #{i.vehicle.catalog_model.descripcion}"
                hash_litros["empresa"] = i.vehicle.catalog_company.nombre
                hash_litros["cantidad"] = i.cantidad
                hash_litros["rendimiento"] = i.rendimiento
                hash_litros["cantidad_cargas"] = 1
                hash_litros["promedio"] = 100
                hash_litros["monto"] = i.monto
                hash_litros["base"] = 100
                i.consumption.n_factura ? hash_litros["factura"] = i.consumption.n_factura : hash_litros["factura"] = "No se asignó una factura." 
                i.vehicle.catalog_area ? hash_litros["area"] = i.vehicle.catalog_area.descripcion : hash_litros["area"] = "No se asignó"
                i.vehicle ? hash_litros["vehiculo"] = i.vehicle.numero_economico : hash_litros["vehiculo"] = "No se asignó"
                i.vehicle.catalog_personal ? hash_litros["personal"] = i.vehicle.catalog_personal.nombre : hash_litros["personal"] = "No se asignó"  
                arreglo_litros.push(hash_litros)
                #byebug
            else
                valor_anterior = cualquiera["cantidad"]
                valor_nuevo = valor_anterior + i.cantidad
                cualquiera["cantidad"] = valor_nuevo
                cantidad_cargas = cualquiera["cantidad_cargas"]
                cantidad_nueva = cantidad_cargas + 1
                cualquiera["cantidad_cargas"] = cantidad_nueva
                rendimiento_anterior = cualquiera["rendimiento"]
                rendimiento_nuevo = rendimiento_anterior + i.rendimiento
                cualquiera["rendimiento"] = rendimiento_nuevo
                cualquiera["promedio"] =  rendimiento_nuevo / cantidad_nueva 
                monto_anterior = cualquiera["monto"]
                monto_nuevo = monto_anterior + i.monto
                cualquiera["monto"] = monto_nuevo
                base = cualquiera["base"]
                cualquiera["base"] = (cualquiera["monto"] * 0.8654)
            end
        end
        #byebug
        return arreglo_litros
    end


    def self.litros_consumo16(fecha_inicio,fecha_fin,cedis,vendor, encabezado)
        arreglo_litros = Array.new()
        #byebug
        #ventas = encabezado.vehicle_consumptions.where(vehicle_id: Vehicle.where(catalog_area_id: CatalogArea.find_by(descripcion: "Ventas").id).ids)
        valuation = Valuation.find_by(tipo_zona: "IVA15GAS", estatus: true)
        ventas = VehicleConsumption.joins(:consumption).joins(:vehicle).where(consumptions: {catalog_branch_id: cedis,catalog_vendor_id:vendor, valuation_id: valuation.id},vehicle_id: Vehicle.where(catalog_area_id: CatalogArea.find_by(descripcion: "Ventas")),fecha: fecha_inicio..fecha_fin)
        #byebug
        ventas.each do |i|
            hash_litros = Hash.new
            cualquiera = arreglo_litros.find {|item| item["no_economico"] == "#{i.vehicle.numero_economico}"}
            #byebug
            if cualquiera.nil?
                hash_litros["no_economico"] = i.vehicle.numero_economico
                hash_litros["tipo_vehiculo"] = "#{i.vehicle.catalog_brand.descripcion} #{i.vehicle.catalog_model.descripcion}"
                hash_litros["empresa"] = i.vehicle.catalog_company.nombre
                hash_litros["cantidad"] = i.cantidad
                hash_litros["rendimiento"] = i.rendimiento
                hash_litros["cantidad_cargas"] = 1
                hash_litros["promedio"] = 100
                hash_litros["monto"] = i.monto
                hash_litros["base"] = 100
                i.consumption.n_factura ? hash_litros["factura"] = i.consumption.n_factura : hash_litros["factura"] = "No se asignó una factura." 
                i.vehicle.catalog_area ? hash_litros["area"] = i.vehicle.catalog_area.descripcion : hash_litros["area"] = "No se asignó"
                i.vehicle ? hash_litros["vehiculo"] = i.vehicle.numero_economico : hash_litros["vehiculo"] = "No se asignó"
                i.vehicle.catalog_personal ? hash_litros["personal"] = i.vehicle.catalog_personal.nombre : hash_litros["personal"] = "No se asignó"                
                arreglo_litros.push(hash_litros)
                #byebug
            else
                valor_anterior = cualquiera["cantidad"]
                valor_nuevo = valor_anterior + i.cantidad
                cualquiera["cantidad"] = valor_nuevo
                cantidad_cargas = cualquiera["cantidad_cargas"]
                cantidad_nueva = cantidad_cargas + 1
                cualquiera["cantidad_cargas"] = cantidad_nueva
                rendimiento_anterior = cualquiera["rendimiento"]
                rendimiento_nuevo = rendimiento_anterior + i.rendimiento
                cualquiera["rendimiento"] = rendimiento_nuevo
                cualquiera["promedio"] =  rendimiento_nuevo / cantidad_nueva 
                monto_anterior = cualquiera["monto"]
                monto_nuevo = monto_anterior + i.monto
                cualquiera["monto"] = monto_nuevo
                base = cualquiera["base"]
                cualquiera["base"] = (cualquiera["monto"] * 0.8654)
            end
        end
        #byebug
        return arreglo_litros
    end

    def self.litros_admin16(fecha_inicio,fecha_fin,cedis,vendor)
        arreglo_litros = Array.new()
        #byebug
        valuation = Valuation.find_by(tipo_zona: "IVA15GAS", estatus: true)
        admin = VehicleConsumption.joins(:consumption).joins(:vehicle).where(consumptions: {catalog_branch_id: cedis,catalog_vendor_id:vendor, valuation_id: valuation.id},vehicle_id: Vehicle.where(catalog_area_id: CatalogArea.find_by(descripcion: "Administrativo")),fecha: fecha_inicio..fecha_fin)
        #byebug
        admin.each do |i|
            hash_litros = Hash.new
            cualquiera = arreglo_litros.find {|item| item["no_economico"] == "#{i.vehicle.numero_economico}"}
            #byebug
            if cualquiera.nil?
                hash_litros["no_economico"] = i.vehicle.numero_economico
                hash_litros["tipo_vehiculo"] = "#{i.vehicle.catalog_brand.descripcion} #{i.vehicle.catalog_model.descripcion}"
                hash_litros["empresa"] = i.vehicle.catalog_company.nombre
                hash_litros["cantidad"] = i.cantidad
                hash_litros["rendimiento"] = i.rendimiento
                hash_litros["cantidad_cargas"] = 1
                hash_litros["promedio"] = 100
                hash_litros["monto"] = i.monto
                hash_litros["base"] = 100
                i.consumption.n_factura ? hash_litros["factura"] = i.consumption.n_factura : hash_litros["factura"] = "No se asignó una factura." 
                i.vehicle.catalog_area ? hash_litros["area"] = i.vehicle.catalog_area.descripcion : hash_litros["area"] = "No se asignó"
                i.vehicle ? hash_litros["vehiculo"] = i.vehicle.numero_economico : hash_litros["vehiculo"] = "No se asignó"
                i.vehicle.catalog_personal ? hash_litros["personal"] = i.vehicle.catalog_personal.nombre : hash_litros["personal"] = "No se asignó"  
                arreglo_litros.push(hash_litros)
                #byebug
            else
                valor_anterior = cualquiera["cantidad"]
                valor_nuevo = valor_anterior + i.cantidad
                cualquiera["cantidad"] = valor_nuevo
                cantidad_cargas = cualquiera["cantidad_cargas"]
                cantidad_nueva = cantidad_cargas + 1
                cualquiera["cantidad_cargas"] = cantidad_nueva
                rendimiento_anterior = cualquiera["rendimiento"]
                rendimiento_nuevo = rendimiento_anterior + i.rendimiento
                cualquiera["rendimiento"] = rendimiento_nuevo
                cualquiera["promedio"] =  rendimiento_nuevo / cantidad_nueva 
                monto_anterior = cualquiera["monto"]
                monto_nuevo = monto_anterior + i.monto
                cualquiera["monto"] = monto_nuevo
                base = cualquiera["base"]
                cualquiera["base"] = (cualquiera["monto"] * 0.8654)
            end
        end
        #byebug
        return arreglo_litros
    end

    def self.litros_almacen16(fecha_inicio,fecha_fin,cedis,vendor)
        arreglo_litros = Array.new()
        #byebug
        
        valuation = Valuation.find_by(tipo_zona: "IVA15GAS", estatus: true)
        almacen = VehicleConsumption.joins(:consumption).joins(:vehicle).where(consumptions: {catalog_branch_id: cedis,catalog_vendor_id:vendor, valuation_id: valuation.id},vehicle_id: Vehicle.where(catalog_area_id: CatalogArea.find_by(descripcion: "Almacén")),fecha: fecha_inicio..fecha_fin)
        #byebug
        almacen.each do |i|
            hash_litros = Hash.new
            cualquiera = arreglo_litros.find {|item| item["no_economico"] == "#{i.vehicle.numero_economico}"}
            #byebug
            if cualquiera.nil?
                hash_litros["no_economico"] = i.vehicle.numero_economico
                hash_litros["tipo_vehiculo"] = "#{i.vehicle.catalog_brand.descripcion} #{i.vehicle.catalog_model.descripcion}"
                hash_litros["empresa"] = i.vehicle.catalog_company.nombre
                hash_litros["cantidad"] = i.cantidad
                hash_litros["rendimiento"] = i.rendimiento
                hash_litros["cantidad_cargas"] = 1
                hash_litros["promedio"] = 100
                hash_litros["monto"] = i.monto
                hash_litros["base"] = 100
                i.consumption.n_factura ? hash_litros["factura"] = i.consumption.n_factura : hash_litros["factura"] = "No se asignó una factura." 
                i.vehicle.catalog_area ? hash_litros["area"] = i.vehicle.catalog_area.descripcion : hash_litros["area"] = "No se asignó"
                i.vehicle ? hash_litros["vehiculo"] = i.vehicle.numero_economico : hash_litros["vehiculo"] = "No se asignó"
                i.vehicle.catalog_personal ? hash_litros["personal"] = i.vehicle.catalog_personal.nombre : hash_litros["personal"] = "No se asignó"  
                arreglo_litros.push(hash_litros)
                #byebug
            else
                valor_anterior = cualquiera["cantidad"]
                valor_nuevo = valor_anterior + i.cantidad
                cualquiera["cantidad"] = valor_nuevo
                cantidad_cargas = cualquiera["cantidad_cargas"]
                cantidad_nueva = cantidad_cargas + 1
                cualquiera["cantidad_cargas"] = cantidad_nueva
                rendimiento_anterior = cualquiera["rendimiento"]
                rendimiento_nuevo = rendimiento_anterior + i.rendimiento
                cualquiera["rendimiento"] = rendimiento_nuevo
                cualquiera["promedio"] =  rendimiento_nuevo / cantidad_nueva 
                monto_anterior = cualquiera["monto"]
                monto_nuevo = monto_anterior + i.monto
                cualquiera["monto"] = monto_nuevo
                base = cualquiera["base"]
                cualquiera["base"] = (cualquiera["monto"] * 0.8654)
            end
        end
        #byebug
        return arreglo_litros
    end


# ---------------------------- consumos con iva --------------------------------

    def self.crear_documento(params, encabezado)
        bandera_error = 0
        mensaje = ""
        bandera_detallado = true
        busqueda_enc = Consumption.find_by(id: encabezado)
        #byebug
        Consumption.transaction do
            #begin
            if busqueda_enc
                doc = File.open(params[:consumption][:factura]) { |f| Nokogiri::XML(f) }
                archivo = Hash.from_xml(doc.to_s)
                hash = archivo["Comprobante"]
                folio_factura = hash["Folio"] 
                serie_factura = hash["Serie"]
                fecha_factura = hash["Fecha"]
                total_factura = hash["Total"].split(".")
                empresa_xml = hash["Receptor"]["Rfc"]
                identificador_unico = hash["Complemento"]["TimbreFiscalDigital"]["UUID"]
                impuestos_traladados = hash["Impuestos"]["TotalImpuestosTrasladados"].to_f
                impuestos_retenidos =  hash["Impuestos"]["TotalImpuestosRetenidos"].to_f
                monto_encabezado = busqueda_enc.monto.round(2).to_s.split(".")
                total = monto_encabezado[0].to_f - total_factura[0].to_f
                total_impuestos = impuestos_traladados + impuestos_retenidos
                if serie_factura == "" or serie_factura.nil?
                    folio_factura_def = "F-#{folio_factura}"
                else
                    folio_factura_def = "#{serie_factura}#{folio_factura}"
                end
                empresa = CatalogCompany.find_by(rfc: empresa_xml)
                if empresa
                    array = []
                    array_i = []
                    array_b = []
                    #obtener todos los importes
                    file = Nokogiri::XML(File.open(params[:consumption][:factura]))    
                    doc_pass = file.xpath("//cfdi:Comprobante/cfdi:Conceptos/cfdi:Concepto")    
                    doc_pass.each do |pass|
                        hash_importe = {}
                        hash_importe[:importe] = pass['Importe']
                        array << hash_importe
                    end
                    #byebug
                    #obtener todos los impuestos
                    doc_pass2 = file.xpath("//cfdi:Comprobante/cfdi:Conceptos/cfdi:Concepto/cfdi:Impuestos/cfdi:Traslados/cfdi:Traslado")    
                    doc_pass2.each do |pass2|
                        hash_impuesto = {}
                        hash_impuesto[:impuesto] = pass2['Importe']
                        array_i << hash_impuesto
                    end
                    
                    if array.length > 2
                        #suma el importe y el impuesto
                        suma =  (0..array.size - 1).each_with_object([]) { |i, obj| obj <<  (array[i][:importe].to_f + array_i[i][:impuesto].to_f).round(2) }
                        #muestra los id de los registros que coinciden con la suma
                        totales = (0..suma.size - 1).each_with_object([]){ |i,obj| obj << VehicleConsumption.where("consumption_id = #{encabezado} and monto >= #{suma[i] - 0.02} and monto <= #{suma[i] + 0.02}").pluck(:id) }
                        prueba = (0..totales.size - 1).each_with_object([]){ |i,obj|
                            obj << if totales[i].empty?
                                puts "**********************No coincide"
                            else
                                # recorrer el de totales y buscar con find_by(key: value)
                                buscar_id = VehicleConsumption.find_by(id: totales[i])
                                puts "****************************Coincide"
                                if buscar_id
                                    buscar_id.update(impuestos:array_i[i][:impuesto].to_f)
                                else
                                    puts "************************ Error al registrar"
                                end
                            end
                        }
                    else
                        bandera_detallado = false
                    #     suma =  (0..array.size - 1).each_with_object([]) { |i, obj| obj <<  (array[i][:importe].to_f + array_i[i][:impuesto].to_f).round(2) }
                    #     #muestra los id de los registros que coinciden con la suma
                    #     totales = (0..suma.size - 1).each_with_object([]){ |i,obj| obj << VehicleConsumption.where("consumption_id = #{encabezado} and monto >= #{suma[i] - 0.02} and monto <= #{suma[i] + 0.02}").pluck(:id) }
                    #     prueba = (0..totales.size - 1).each_with_object([]){ |i,obj|
                    #         obj << if totales[i].empty?
                    #             puts "No coincide"
                    #         else
                    #             # recorrer el de totales y buscar con find_by(key: value)
                    #             buscar_id = VehicleConsumption.find_by(id: totales[i])
                    #             puts "Coincide"
                    #             if buscar_id
                    #                 division_mto_fact = monto_encabezado / buscar_id.monto
                    #                 prorrat_imp = division_mto_fact * total_impuestos

                    #                 buscar_id.update(impuestos: prorrat_imp.to_f)
                    #             else
                    #                 puts "Error al registrar"
                    #             end
                    #         end
                    #     }

                    end
                    
                    # #suma el importe y el impuesto
                    # suma =  (0..array.size - 1).each_with_object([]) { |i, obj| obj <<  (array[i][:importe].to_f + array_i[i][:impuesto].to_f).round(2) }
                    # #muestra los id de los registros que coinciden con la suma
                    # totales = (0..suma.size - 1).each_with_object([]){ |i,obj| obj << VehicleConsumption.where("consumption_id = #{encabezado} and monto >= #{suma[i] - 0.02} and monto <= #{suma[i] + 0.02}").pluck(:id) }
                    # prueba = (0..totales.size - 1).each_with_object([]){ |i,obj|
                    #     obj << if totales[i].empty?
                    #         puts "No coincide"
                    #     else
                    #         # recorrer el de totales y buscar con find_by(key: value)
                    #         buscar_id = VehicleConsumption.find_by(id: totales[i])
                    #         puts "Coincide"
                    #         if buscar_id
                    #             buscar_id.update(impuestos:array_i[i][:impuesto].to_f)
                    #         else
                    #             puts "Error al registrar"
                    #         end
                    #     end
                    # }
                    #byebug
                    if monto_encabezado[0].to_f == total_factura[0].to_f #total >= 0 and total <= 1

                        if busqueda_enc.update(factura: params[:consumption][:factura], n_factura: folio_factura_def, fecha_factura: fecha_factura,impuestos:total_impuestos,uuid:identificador_unico,usuario_modifico:"#{User.current_user.name} #{User.current_user.last_name}", es_detallado: bandera_detallado, company_id: empresa.id)
                            ver_registros= VehicleConsumption.where(consumption_id:encabezado,impuestos: nil)
                            #byebug
                            if ver_registros.count > 0

                                ver_registros.each do |enc|
                                    bque_veh = VehicleTransferLog.where(vehicle_id: enc.vehicle_id, fecha: busqueda_enc.fecha_inicio..busqueda_enc.fecha_fin) 
                                    if bque_veh.length > 0
                                        enc.update(catalog_branch_id: bque_veh.last.catalog_branch_id)
                                    else
                                        bque_veh2 = VehicleTransferLog.where("vehicle_id = ? and fecha <= ?", enc.vehicle_id, busqueda_enc.fecha_inicio)
                                        if bque_veh2.length > 0
                                            enc.update(catalog_branch_id: bque_veh2.last.catalog_branch_id)
                                        else
                                            enc.update(catalog_branch_id: enc.vehicle.catalog_branch_id)
                                        end
                                    end
                                end
                                bandera_error = 1
                                if bandera_detallado == true
                                    mensaje = "La factura se adjuntó con éxito, pero algúnos impuestos no coincidieron. Favor de actualizar manualmente los impuestos."
                                else
                                    mensaje = "La factura se adjuntó con éxito"
                                end
                            else
                                bandera_error = 4                
                            end
                        else 
                            bandera_error = 3
                            busqueda_enc.errors.full_messages.each do |error|
                                mensaje += "#{error}. "
                            end
                        end
                    else
                        bandera_error = 1
                        mensaje = "El monto ya registrado y el total de la factura no coinciden."
                    end
                else
                    bandera_error = 1
                    mensaje = "No se encontró la empresa correspondiente a la factura. Por favor revise que el RFC de la empresa sea correcto."
                end
            else
                bandera_error = 1
                mensaje = "No se encontró el registro del encabezado."
            end
            if bandera_error == 4
                mensaje = "Documento agregado correctamente." 
                return mensaje,bandera_error
            else
                return mensaje, bandera_error
                raise ActiveRecord::Rollback
            end
        end
        # rescue ActiveRecord::RecordInvalid => e
        #     mensaje += "Ocurrió un error al guardar la factura,, por lo que la operación no pudo continuar: #{e}."
        #     bandera_error = true
        #     return mensaje, bandera_error
        # rescue Exception => error
        #     mensaje += "Ocurrió un error desconocido: #{error}. Favor de contactar al área de soporte."
        #     bandera_error = true
        #     return mensaje, bandera_error
    end


    def enviar_json_redondeado(current_user)
        @current_user = current_user
        @objeto_principal = []
        @polizaInput = []
        @poliza = []
        @base = []
        @asientoDeDiario = []
        @info_adicional = []
        impuestos_totales = 0
        hash_principal = Hash.new
        hash_polizaInput = Hash.new
        hash_poliza = Hash.new
        hash_base = Hash.new
        hash_info_adicional = Hash.new
        hash_poliza["usuario"] = @current_user.correo_combustibles
        hash_poliza["numeroTransaccion"] = "1"
        hash_poliza["numeroLinea"] = "1000"
        hash_poliza["numeroBatch"] = "0"
        cat_company = CatalogCompany.find_by(id: self.company_id)
        hash_poliza["compañiaDocumento"] = cat_company.clave
        #hash_poliza["compañiaDocumento"] = "00001"
        hash_poliza["tipoDocumento"] = "PV"
        hash_poliza["numeroProveedor"] = self.catalog_vendor.clave #"49965"#self.vehicle_consumptions[0].vehicle.catalog_company.clave    sacar de la relacion
        hash_poliza["numeroBeneficiario"] = self.catalog_vendor.clave  #"49965"#self.vehicle_consumptions[0].vehicle.catalog_company.clave  sacar de la relacion con proveedor numero de (proveedor)
        hash_poliza["fechaFactura"] = "1#{self.fecha_factura.strftime("%y")}#{(self.fecha_factura).strftime("%j")}"
        hash_poliza["fechaEfectiva"] = "1#{self.created_at.strftime("%y")}#{(self.created_at).strftime("%j")}"
        hash_poliza["fechaVencimiento"] = "" #"120252" 
        hash_poliza["fechaDescuento"] = "1#{self.fecha_factura.strftime("%y")}#{(self.fecha_factura).strftime("%j")}" #"120252"
        hash_poliza["fechaLM"] = "1#{self.fecha_aplicacion.strftime("%y")}#{(self.fecha_aplicacion).strftime("%j")}"
        hash_poliza["añoFiscal"] = "0"
        #hash_poliza["sigloFiscal"] = "21"
        hash_poliza["sigloFiscal"] = "20"
        hash_poliza["periodoFiscal"] = "0"
        hash_poliza["compañia"] = self.vehicle_consumptions[0].vehicle.catalog_company.clave#"DYENCALADA"
        hash_poliza["tipoBatch"] = "V"
        hash_poliza["transaccionBalanceada"] = "Y"
        hash_poliza["estatusDePago"] = "H"
        valuation = ValuationsBranch.find_by(catalog_vendor_id: self.catalog_vendor_id, catalog_branch_id: self.catalog_branch_id)
        if valuation
            valor_iva = valuation.valuation.valor / 100
        else
            valor_iva = 0.16
        end
        #imponible = (self.monto.to_f - self.impuestos.to_f).round(2)
        #byebug
        imponible = (self.impuestos.to_f / valor_iva)
        imponible_global = ((imponible) * 100).to_i

        acumulado_impuesto_base_cero = 0
        acumulado_monto_total_base_cero = 0
        acumulado_imponible_base_cero = 0
        acumulado_impuesto = 0
        acumulado_monto_total = 0
        acumulado_imponible = 0


        bandera_base_cero = false
        bandera_impuesto = self.impuestos.ceil(2) / valor_iva
        if ((self.monto - self.impuestos).ceil(2) - bandera_impuesto) > 0
            bandera_base_cero = true
        end
        valor_importe_global = (((self.impuestos / valor_iva).ceil(2) * (1 + valor_iva)).ceil(2) * 100).ceil(2)
        hash_poliza["importe"] = (valor_importe_global.to_f).to_i
        hash_poliza["importePendiente"] = (valor_importe_global.to_f).to_i
        hash_poliza["importeImponible"] = ((self.impuestos / valor_iva).ceil(2) * 100).ceil(2).to_i

        hash_poliza["importeImpuesto"] = (self.impuestos.to_f.floor(2)* 100).ceil
        hash_poliza["tasaFiscal"] = "IVA15GAS"
        hash_poliza["explicacionFiscal"] = "V"
        hash_poliza["tipoMoneda"] = "D"
        hash_poliza["moneda"] = "MXP"
        hash_poliza["glClass"] = self.catalog_vendor.compenlm
        #hash_poliza["cuentaBancaria"] = "00000000" #sacar de vendors -------------------------------------- la agarre de vendors
        #hash_poliza["cuentaBancaria"] = ""
        hash_poliza["modoDeCuenta"] = "2"
        #hash_poliza["unidadDeNegocio"] = self.catalog_branch.unidad_negocio
        area_mayor = nil
        bandera_total = 0
        CatalogArea.all.each do |area|
            cuenta = self.vehicle_consumptions.joins(:vehicle).where(vehicles: {catalog_area_id: area.id}).count
            if cuenta > 0
                suma = self.vehicle_consumptions.joins(:vehicle).where(vehicles: {catalog_area_id: area.id}).sum(:monto)
                if suma > bandera_total
                    bandera_total = suma
                    area_mayor = area.clave
                end
            end
        end
        #hash_poliza["unidadDeNegocio"] = "09990706"
        hash_poliza["unidadDeNegocio"] = "#{self.catalog_branch.unidad_negocio}#{area_mayor}"
        #byebug
        hash_poliza["plazo"] = self.catalog_vendor.plazo #sacar de vendors -----------------------------------------
        hash_poliza["factura"] = self.n_factura # "145525"#self.n_factura
        hash_poliza["nameRemark"] = "#{self.catalog_branch.abreviacion} COMB #{self.fecha_inicio.strftime("%d")}-#{self.fecha_fin.strftime("%d")} #{ I18n.l(self.fecha_fin, format: '%B') }"
        hash_poliza["instrumentoDePago"] = self.catalog_vendor.instrumentopago
        hash_poliza["originador"] = @current_user.correo_combustibles
        hash_poliza["usuarioActualizacion"] = @current_user.correo_combustibles
        hash_poliza["idPrograma"] = self.id
        hash_poliza["fechaActualizacion"] = "1#{Time.zone.now.strftime("%y")}#{(Time.zone.now).strftime("%j")}" #"1#{self.updated_at.strftime("%y")}#{(self.updated_at).strftime("%j")}"
        hash_poliza["horaActualizacion"] = Time.zone.now.strftime("%H%M%S")
        hash_poliza["estacionDeTrabajo"] = "WEB91a"


        if bandera_base_cero == true
            hash_base["usuario"] = @current_user.correo_combustibles
            hash_base["numeroTransaccion"] = "1"
            hash_base["numeroLinea"] = "2000"
            hash_base["numeroBatch"] = "0"
            hash_base["compañiaDocumento"] = "00001"
            hash_base["tipoDocumento"] = "PV"
            hash_base["numeroProveedor"] = self.catalog_vendor.clave#"49965"#self.vehicle_consumptions[0].vehicle.catalog_company.clave    sacar de la relacion
            hash_base["numeroBeneficiario"] = self.catalog_vendor.clave #"49965"#self.vehicle_consumptions[0].vehicle.catalog_company.clave  sacar de la relacion con proveedor numero de (proveedor)
            hash_base["fechaFactura"] = "1#{self.fecha_factura.strftime("%y")}#{(self.fecha_factura).strftime("%j")}"
            hash_base["fechaEfectiva"] = "1#{self.created_at.strftime("%y")}#{(self.created_at).strftime("%j")}"
            hash_base["fechaVencimiento"] = "" #"120252" 
            hash_base["fechaDescuento"] = "1#{self.fecha_factura.strftime("%y")}#{(self.fecha_factura).strftime("%j")}" #"120252"
            hash_base["fechaLM"] = "1#{self.fecha_aplicacion.strftime("%y")}#{(self.fecha_aplicacion).strftime("%j")}"
            hash_base["añoFiscal"] = "0"
            hash_base["sigloFiscal"] = "20"
            hash_base["periodoFiscal"] = "0"
            hash_base["compañia"] = self.vehicle_consumptions[0].vehicle.catalog_company.clave#"DYENCALADA"
            hash_base["tipoBatch"] = "V"
            hash_base["transaccionBalanceada"] = "Y"
            hash_base["estatusDePago"] = "H"
            importes = (((self.monto - self.impuestos).ceil(2) - bandera_impuesto) * 100).ceil
            hash_base["importe"] =  importes
            hash_base["importePendiente"] =   importes 
            hash_base["importeImponible"] =  importes
            hash_base["importeImpuesto"] = "0"
            hash_base["tasaFiscal"] = "IVA0GAS"
            hash_base["explicacionFiscal"] = "V"
            hash_base["tipoMoneda"] = "D"
            hash_base["moneda"] = "MXP"
            hash_base["glClass"] = self.catalog_vendor.compenlm
            hash_base["modoDeCuenta"] = "2"
            hash_base["unidadDeNegocio"] = "#{self.catalog_branch.unidad_negocio}#{area_mayor}"
            hash_base["plazo"] = self.catalog_vendor.plazo
            hash_base["factura"] = self.n_factura 
            hash_base["nameRemark"] = "#{self.catalog_branch.abreviacion} COMB #{self.fecha_inicio.strftime("%d")}-#{self.fecha_fin.strftime("%d")} #{ I18n.l(self.fecha_fin, format: '%B') }"
            hash_base["instrumentoDePago"] = self.catalog_vendor.instrumentopago
            hash_base["originador"] = @current_user.correo_combustibles
            hash_base["usuarioActualizacion"] = @current_user.correo_combustibles
            hash_base["idPrograma"] = self.id
            hash_base["fechaActualizacion"] = "1#{Time.zone.now.strftime("%y")}#{(Time.zone.now).strftime("%j")}"
            hash_base["horaActualizacion"] = Time.zone.now.strftime("%H%M%S")
            hash_base["estacionDeTrabajo"] = "WEB91a"
            hash_polizaInput["poliza"] = hash_poliza,hash_base
        else
            @poliza << hash_poliza
            hash_polizaInput["poliza"] = @poliza
        end


            @costos = VehicleConsumption.joins(:consumption).joins(:vehicle).where(consumptions: {id: self.id}).group("vehicles.catalog_area_id, consumptions.catalog_branch_id, vehicles.catalog_branch_id").select("sum(vehicle_consumptions.monto) as monto, sum(vehicle_consumptions.impuestos) as impuestos, consumptions.catalog_branch_id as cediscarga, vehicles.catalog_branch_id as cedisorigen, vehicles.catalog_area_id as catalog_area_id")
            @costos.each_with_index do |ac,index|

                #if @costos != []
                hash_asientoDeDiario = Hash.new 
                hash_asientoDeDiario["numeroLinea"] = "#{index+1}000"
                hash_asientoDeDiario["numeroBatch"] = "0"
                hash_asientoDeDiario["fechaLM"] = "1#{self.fecha_fin.strftime("%y")}#{(self.fecha_fin).strftime("%j")}"
                hash_asientoDeDiario["tipoBatch"] = "V"
                #hash_asientoDeDiario["compañia"] = self.vehicle_consumptions[0].vehicle.catalog_company.clave
                hash_asientoDeDiario["compañia"] = hash_poliza["compañia"]
                catalogo = CatalogArea.find_by(id: ac.catalog_area_id)
                #byebug
                if catalogo.descripcion == "Operaciones"
                    if catalogo == nil
                        @mensaje_error  = ["No se encontro un Área con los datos proporcionados, por favor revise la información. Folio: #{self.folio}"]
                        return [@mensaje_error,false]
                    end

                end
                if valuation
                    cedis_de_carga = CatalogBranch.find_by(id: ac.cediscarga)
                    if valuation.catalog_branch.catalog_company_id == cedis_de_carga.catalog_company_id
                        tasa_costo = ValuationsBranch.find_by(catalog_branch_id: cedis_de_carga.id, valuation_id: valuation.valuation.id)
                        if tasa_costo
                            hash_asientoDeDiario["numeroCuenta"] = tasa_costo.valuation.cuenta
                        else
                            @mensaje_error  = ["El cedis: #{cedis_de_carga.decripcion} no tiene asignada la tasa correspondiente al iva de la factura."]
                            return [@mensaje_error,false]
                        end
                    else
                        account_impact = AccountingImpact.find_by(catalog_branch_id: self.catalog_branch_id,  cuenta_contable: "Otros gastos",catalog_area_id:catalogo.id,status:true)#.select(:nombre)#    "01060102.6103.0101"
                        if account_impact == nil
                            @mensaje_error  = ["No se encontró el Numero de cuenta para el cedis: #{self.catalog_branch.decripcion} y área: #{catalogo.descripcion} para el concepto de combustible otros gastos, por favor revise la información. Folio: #{self.folio}"]
                            return [@mensaje_error,false] 
                        else
                            hash_asientoDeDiario["numeroCuenta"] = account_impact.nombre
                        end
                    end
                else
                    #@mensaje_error  = ["No se encontró el Numero de cuenta para el cedis: #{self.catalog_branch.decripcion} y área: #{catalogo.descripcion} para el concepto de combustible, por favor revise la información. Folio: #{self.folio}"]
                    @mensaje_error  = ["El cedis: #{self.catalog_branch.decripcion} no tiene asignada la tasa correspondiente al iva de la factura."]
                    return [@mensaje_error,false]
                end
                #------------------------------------------------------------------------------------
                #no se si esta bien estos campos
                hash_asientoDeDiario["modoDeCuenta"] = "2"
                hash_asientoDeDiario["subledger"] = self.catalog_vendor.clave
                hash_asientoDeDiario["subledgerType"] = "A"
                #---------------------------------------------------------------------------------------
                hash_asientoDeDiario["tipoLibro"] = "AA"
                hash_asientoDeDiario["periodoFiscal"] = "0"
                #hash_asientoDeDiario["sigloFiscal"] = "21"
                hash_asientoDeDiario["sigloFiscal"] = "20"
                hash_asientoDeDiario["añoFiscal"] = "0"
                hash_asientoDeDiario["moneda"] = "MXP"
                #monto_total = @costos.map{|x| x.monto}.inject(:+)
                #impuestos_total = @costos.map{|x| x.impuestos}.inject(:+)
                if self.es_detallado
                    bandera_impuesto = (ac.impuestos.to_f.ceil(2) / valor_iva).ceil(2)
                    if ((ac.monto.to_f - ac.impuestos) - bandera_impuesto) > 0
                        bandera_base_cero = true
                    end
                    #byebug
                    if bandera_base_cero == true
                        monto_total = (ac.impuestos.ceil(2) / valor_iva).ceil(2)
                        impuestos_total = ac.impuestos.to_f

                        impuesto_base_renglon = ac.impuestos.to_f
                        monto_base_renglon = ac.monto.to_f
                        impuesto_base_cero_renglon = ac.monto - monto_total
                        #if index == 0
                        #end
                        #impuestos_totales = impuestos_totales + ac.impuestos.to_f 
                        impuesto_base_cero = ((ac.monto.ceil(2) - ac.impuestos.ceil(2)) - monto_total).ceil(2)
                        imponible = monto_total.to_f
                        #byebug
                        #valor_diario_monto = (imponible.ceil(2)*100).ceil
                        valor_diario_monto = (((imponible.ceil(2) + impuesto_base_cero.ceil(2)).ceil(2)*100).ceil(2)).to_i
                        #byebug
                        acumulado_impuesto_base_cero += (impuesto_base_cero.ceil(2)*100).ceil
                        acumulado_monto_total_base_cero += (monto_total.ceil(2)*100).ceil
                        acumulado_imponible_base_cero += (valor_diario_monto.ceil(2)).ceil
                    else
                        monto_total = ac.monto.to_f
                        impuestos_total = ac.impuestos.to_f
                        #impuestos_totales = impuestos_totales + ac.impuestos.to_f 
                        imponible = (monto_total.to_f - impuestos_total.to_f)
                        valor_diario_monto = (((imponible.ceil(2)*100).ceil(2)).to_f).to_s
                        acumulado_impuesto += (impuestos_total.ceil(2)*100).ceil
                        acumulado_monto_total += (monto_total.ceil(2)*100).ceil
                        acumulado_imponible += (valor_diario_monto.ceil(2)).ceil
                    end
                else

                    division_mto_fact = (ac.monto / self.monto).ceil(2)
                    #base_cero_imp = self.impuestos.to_f.floor(2) / valor_iva

                    prorrat_imp = (division_mto_fact * self.impuestos).ceil(2)

                    bandera_impuesto = (self.impuestos.to_f.ceil(2) / valor_iva).ceil(2)

                    bandera_impuesto_renglon = prorrat_imp / valor_iva

                    prorrat_base_cero = (division_mto_fact * ((self.monto - self.impuestos) - bandera_impuesto))


                    if ((ac.monto.to_f - prorrat_imp) - bandera_impuesto) > 0
                        bandera_base_cero = true
                    end
                    #byebug
                    if bandera_base_cero == true
                        #prorrat_imp_linea = self.impuestos * (division_mto_fact)
                        monto_total = ac.monto - prorrat_imp
                        impuestos_total = prorrat_imp.to_f

                        impuesto_base_renglon = prorrat_imp.to_f
                        monto_base_renglon = prorrat_imp.to_f
                        impuesto_base_cero_renglon = prorrat_base_cero

                        impuesto_base_cero = prorrat_base_cero

                        imponible = monto_total.to_f

                        valor_diario_monto = ((imponible.ceil(2))*100).ceil
                        #byebug
                        acumulado_impuesto_base_cero += (impuesto_base_cero.ceil(2)*100).ceil
                        acumulado_monto_total_base_cero += (monto_total.ceil(2)*100).ceil
                        acumulado_imponible_base_cero += (valor_diario_monto.ceil(2)).ceil
                    else
                        monto_total = ac.monto - prorrat_imp
                        impuestos_total = prorrat_imp.to_f

                        #imponible = (monto_total.to_f - impuestos_total.to_f)
                        valor_diario_monto = (monto_total.ceil(2)*100).ceil
                        acumulado_impuesto += (impuestos_total.ceil(2)*100).ceil
                        acumulado_monto_total += (monto_total.ceil(2)*100).ceil
                        acumulado_imponible += (valor_diario_monto.ceil(2)).ceil
                    end
                end
                # imponible = (self.monto/1.16).round(2)
                #     if index == 0
                # valor_div = (valor_diario_monto.to_f/100)/(imponible_global.to_f/100).round(4)
                # valor_mult = (valor_div * base.round(2)).round(2)
                # monto_base = ((valor_diario_monto.to_f/100) - valor_mult).round(2)
                # hash_asientoDeDiario["monto"]  = (monto_base * 100).to_i
                #byebug
                    if (@costos.length - 1) == index
                        #monto_total = @costos.map{|x| x.monto}.inject(:+)
                        #byebug
                        if @asientoDeDiario.length > 0 
                            valor_bandera = valor_diario_monto + @asientoDeDiario.map{|x| x["monto"]}.inject(:+)
                        else
                            valor_bandera = valor_diario_monto
                        end
                        if bandera_base_cero == true
                            #byebug
                            resta_diario_monto =  ((((self.impuestos / valor_iva).ceil(2) * 100).ceil(2) + importes) - valor_bandera).to_f
                        else
                            resta_diario_monto = ((((self.impuestos / valor_iva).ceil(2) * 100).ceil(2)) - valor_bandera).to_f
                        end
                        if resta_diario_monto == 1
                            hash_asientoDeDiario["monto"] = valor_diario_monto + 1
                        elsif resta_diario_monto == -1 
                            hash_asientoDeDiario["monto"] = valor_diario_monto - 1
                        else
                            hash_asientoDeDiario["monto"] = valor_diario_monto
                        end
                    else
                        hash_asientoDeDiario["monto"] = valor_diario_monto
                    end
                    #  (imponible * 100).to_i #((self.monto * 0.8654)*100).to_i
                #     else
                #     hash_asientoDeDiario["monto"] = ((imponible * 0.16).round(2) *100).to_i#((self.monto - (self.monto * 0.8654))*100).to_i
                #     end

                hash_asientoDeDiario["explicacion"] = self.catalog_vendor.razonsocial.first(30) #"Servicios Gasolineros de Mexic"# //eeee
                if ac.cedisorigen == ac.cediscarga
                    hash_asientoDeDiario["observaciones"] = "#{self.catalog_branch.abreviacion} COMB #{self.fecha_inicio.strftime("%d")}-#{self.fecha_fin.strftime("%d")} #{ I18n.l(self.fecha_fin, format: '%B')}" # cambiar las 3 primeras letras del cedis comb se queda
                else
                    hash_asientoDeDiario["observaciones"] = "#{self.catalog_branch.catalog_company.abreviatura} #{self.catalog_branch.abreviacion} COMB #{self.fecha_inicio.strftime("%d")}-#{self.fecha_fin.strftime("%d")} #{ I18n.l(self.fecha_fin, format: '%B')}" # cambiar las 3 primeras letras del cedis comb se queda
                end
                hash_asientoDeDiario["numeroBeneficiario"] = self.catalog_vendor.clave # self.vehicle_consumptions[0].vehicle.catalog_company.clave
                #aun no esta
                hash_asientoDeDiario["factura"] = self.n_factura #""#"145525"
                #----------------------------------

                hash_asientoDeDiario["fechaFactura"] = "1#{self.fecha_fin.strftime("%y")}#{(self.fecha_fin).strftime("%j")}"
                hash_asientoDeDiario["fechaEfectiva"] = "1#{self.created_at.strftime("%y")}#{(self.created_at).strftime("%j")}"
                hash_asientoDeDiario["codigoMoneda"] = "D"
                hash_asientoDeDiario["originador"] = @current_user.correo_combustibles #sacar de usuario de correo verificar que sea gafi.com.mx si no DYENCALADA 
                hash_asientoDeDiario["usuarioActualizacion"] = @current_user.correo_combustibles #sacar de usuario de correo verificar que sea gafi.com.mx si no DYENCALADA 
                hash_asientoDeDiario["idPrograma"] = self.id
                hash_asientoDeDiario["fechaActualizacion"] = "1#{Time.zone.now.strftime("%y")}#{(Time.zone.now).strftime("%j")}"
                hash_asientoDeDiario["horaActualizacion"] = Time.zone.now.strftime("%H%M%S")
                hash_asientoDeDiario["estacionDeTrabajo"]  = "WEB91a"
                @asientoDeDiario <<hash_asientoDeDiario
                #byebug
            #end
        end


        
        hash_info_adicional["UUID"] = self.uuid
        @info_adicional << hash_info_adicional
        hash_polizaInput["asientoDeDiario"] = @asientoDeDiario
        hash_polizaInput["infoAdicional"] = @info_adicional
        @polizaInput << hash_polizaInput
        hash_principal["polizaInput"] = @polizaInput[0]
        @objeto_principal << hash_principal
        # comentar de aquí a...
        paremetro_nombre = Parameter.find_by(nombre:"Url Poliza JDE")
        url = URI(paremetro_nombre.valor_extendido)
        https = Net::HTTP.new(url.host, url.port);
        request = Net::HTTP::Put.new(url)
        request["Content-Type"] = "application/json"
        request["Accept"] = "application/json"
        request.body = @objeto_principal[0].to_json
        response = https.request(request)
        @json_parciado = []
        respuesta = JSON.parse response.body
        if respuesta[0].nil?
            @json_parciado.push(respuesta)
        else
            @json_parciado = respuesta
        end
        #byebug
        JdeLog.create(
            fecha: Time.zone.now.to_date,
            hora: Time.zone.now,
            json_enviado: @objeto_principal,
            respuesta: @json_parciado
        )
            
        if @json_parciado.map{|x| x['Exitoso']}.include?(false) 
            #return [@json_parciado,false]
            enviar_json_comb_uno(@current_user)
        else
            return [@json_parciado,true]
        end

        

        # aquí, para no  enviar  el json a JDE
        #return[@objeto_principal,true]   #descomentar este return para que ver el json que se esta mandando a JDE
    end

    
    def enviar_json_comb_uno(current_user)
        @current_user = current_user
        @objeto_principal = []
        @polizaInput = []
        @poliza = []
        @base = []
        @asientoDeDiario = []
        @info_adicional = []
        impuestos_totales = 0
        hash_principal = Hash.new
        hash_polizaInput = Hash.new
        hash_poliza = Hash.new
        hash_base = Hash.new
        hash_info_adicional = Hash.new
        hash_poliza["usuario"] = @current_user.correo_combustibles
        hash_poliza["numeroTransaccion"] = "1"
        hash_poliza["numeroLinea"] = "1000"
        hash_poliza["numeroBatch"] = "0"
        cat_company = CatalogCompany.find_by(id: self.company_id)
        hash_poliza["compañiaDocumento"] = cat_company.clave
        #hash_poliza["compañiaDocumento"] = "00001"
        hash_poliza["tipoDocumento"] = "PV"
        hash_poliza["numeroProveedor"] = self.catalog_vendor.clave #"49965"#self.vehicle_consumptions[0].vehicle.catalog_company.clave    sacar de la relacion
        hash_poliza["numeroBeneficiario"] = self.catalog_vendor.clave  #"49965"#self.vehicle_consumptions[0].vehicle.catalog_company.clave  sacar de la relacion con proveedor numero de (proveedor)
        hash_poliza["fechaFactura"] = "1#{self.fecha_factura.strftime("%y")}#{(self.fecha_factura).strftime("%j")}"
        hash_poliza["fechaEfectiva"] = "1#{self.created_at.strftime("%y")}#{(self.created_at).strftime("%j")}"
        hash_poliza["fechaVencimiento"] = "" #"120252" 
        hash_poliza["fechaDescuento"] = "1#{self.fecha_factura.strftime("%y")}#{(self.fecha_factura).strftime("%j")}" #"120252"
        hash_poliza["fechaLM"] = "1#{self.fecha_aplicacion.strftime("%y")}#{(self.fecha_aplicacion).strftime("%j")}"
        hash_poliza["añoFiscal"] = "0"
        #hash_poliza["sigloFiscal"] = "21"
        hash_poliza["sigloFiscal"] = "20"
        hash_poliza["periodoFiscal"] = "0"
        hash_poliza["compañia"] = self.vehicle_consumptions[0].vehicle.catalog_company.clave#"DYENCALADA"
        hash_poliza["tipoBatch"] = "V"
        hash_poliza["transaccionBalanceada"] = "Y"
        hash_poliza["estatusDePago"] = "H"
        valuation = ValuationsBranch.find_by(catalog_vendor_id: self.catalog_vendor_id, catalog_branch_id: self.catalog_branch_id)
        if valuation
            valor_iva = valuation.valuation.valor / 100
        else
            valor_iva = 0.16
        end
        #imponible = (self.monto.to_f - self.impuestos.to_f).round(2)
        #byebug
        imponible = (self.impuestos.to_f / valor_iva)
        imponible_global = ((imponible) * 100).to_i

        acumulado_impuesto_base_cero = 0
        acumulado_monto_total_base_cero = 0
        acumulado_imponible_base_cero = 0
        acumulado_impuesto = 0
        acumulado_monto_total = 0
        acumulado_imponible = 0


        bandera_base_cero = false
        bandera_impuesto = (self.impuestos.round(2) / valor_iva).round(2)
        if ((self.monto - self.impuestos).round(2) - bandera_impuesto) > 0
            bandera_base_cero = true
        end
        valor_importe_global = (((self.impuestos / valor_iva).round(2) * (1 + valor_iva)).round(2) * 100).round(2)
        hash_poliza["importe"] = (valor_importe_global.to_f).to_i
        hash_poliza["importePendiente"] = (valor_importe_global.to_f).to_i
        hash_poliza["importeImponible"] = ((self.impuestos / valor_iva).round(2) * 100).round(2).to_i

        hash_poliza["importeImpuesto"] = (self.impuestos.to_f.floor(2)* 100).round
        hash_poliza["tasaFiscal"] = "IVA15GAS"
        hash_poliza["explicacionFiscal"] = "V"
        hash_poliza["tipoMoneda"] = "D"
        hash_poliza["moneda"] = "MXP"
        hash_poliza["glClass"] = self.catalog_vendor.compenlm
        #hash_poliza["cuentaBancaria"] = "00000000" #sacar de vendors -------------------------------------- la agarre de vendors
        #hash_poliza["cuentaBancaria"] = ""
        hash_poliza["modoDeCuenta"] = "2"
        #hash_poliza["unidadDeNegocio"] = self.catalog_branch.unidad_negocio
        area_mayor = nil
        bandera_total = 0
        CatalogArea.all.each do |area|
            cuenta = self.vehicle_consumptions.joins(:vehicle).where(vehicles: {catalog_area_id: area.id}).count
            if cuenta > 0
                suma = self.vehicle_consumptions.joins(:vehicle).where(vehicles: {catalog_area_id: area.id}).sum(:monto)
                if suma > bandera_total
                    bandera_total = suma
                    area_mayor = area.clave
                end
            end
        end
        #hash_poliza["unidadDeNegocio"] = "09990706"
        hash_poliza["unidadDeNegocio"] = "#{self.catalog_branch.unidad_negocio}#{area_mayor}"
        #byebug
        hash_poliza["plazo"] = self.catalog_vendor.plazo #sacar de vendors -----------------------------------------
        hash_poliza["factura"] = self.n_factura # "145525"#self.n_factura
        hash_poliza["nameRemark"] = "#{self.catalog_branch.abreviacion} COMB #{self.fecha_inicio.strftime("%d")}-#{self.fecha_fin.strftime("%d")} #{ I18n.l(self.fecha_fin, format: '%B') }"
        hash_poliza["instrumentoDePago"] = self.catalog_vendor.instrumentopago
        hash_poliza["originador"] = @current_user.correo_combustibles
        hash_poliza["usuarioActualizacion"] = @current_user.correo_combustibles
        hash_poliza["idPrograma"] = self.id
        hash_poliza["fechaActualizacion"] = "1#{Time.zone.now.strftime("%y")}#{(Time.zone.now).strftime("%j")}" #"1#{self.updated_at.strftime("%y")}#{(self.updated_at).strftime("%j")}"
        hash_poliza["horaActualizacion"] = Time.zone.now.strftime("%H%M%S")
        hash_poliza["estacionDeTrabajo"] = "WEB91a"


        if bandera_base_cero == true
            hash_base["usuario"] = @current_user.correo_combustibles
            hash_base["numeroTransaccion"] = "1"
            hash_base["numeroLinea"] = "2000"
            hash_base["numeroBatch"] = "0"
            hash_base["compañiaDocumento"] = "00001"
            hash_base["tipoDocumento"] = "PV"
            hash_base["numeroProveedor"] = self.catalog_vendor.clave#"49965"#self.vehicle_consumptions[0].vehicle.catalog_company.clave    sacar de la relacion
            hash_base["numeroBeneficiario"] = self.catalog_vendor.clave #"49965"#self.vehicle_consumptions[0].vehicle.catalog_company.clave  sacar de la relacion con proveedor numero de (proveedor)
            hash_base["fechaFactura"] = "1#{self.fecha_factura.strftime("%y")}#{(self.fecha_factura).strftime("%j")}"
            hash_base["fechaEfectiva"] = "1#{self.created_at.strftime("%y")}#{(self.created_at).strftime("%j")}"
            hash_base["fechaVencimiento"] = "" #"120252" 
            hash_base["fechaDescuento"] = "1#{self.fecha_factura.strftime("%y")}#{(self.fecha_factura).strftime("%j")}" #"120252"
            hash_base["fechaLM"] = "1#{self.fecha_aplicacion.strftime("%y")}#{(self.fecha_aplicacion).strftime("%j")}"
            hash_base["añoFiscal"] = "0"
            hash_base["sigloFiscal"] = "20"
            hash_base["periodoFiscal"] = "0"
            hash_base["compañia"] = self.vehicle_consumptions[0].vehicle.catalog_company.clave#"DYENCALADA"
            hash_base["tipoBatch"] = "V"
            hash_base["transaccionBalanceada"] = "Y"
            hash_base["estatusDePago"] = "H"
            importes = (((self.monto - self.impuestos).round(2) - bandera_impuesto) * 100).round
            hash_base["importe"] =  importes
            hash_base["importePendiente"] =   importes 
            hash_base["importeImponible"] =  importes
            hash_base["importeImpuesto"] = "0"
            hash_base["tasaFiscal"] = "IVA0GAS"
            hash_base["explicacionFiscal"] = "V"
            hash_base["tipoMoneda"] = "D"
            hash_base["moneda"] = "MXP"
            hash_base["glClass"] = self.catalog_vendor.compenlm
            hash_base["modoDeCuenta"] = "2"
            hash_base["unidadDeNegocio"] = "#{self.catalog_branch.unidad_negocio}#{area_mayor}"
            hash_base["plazo"] = self.catalog_vendor.plazo
            hash_base["factura"] = self.n_factura 
            hash_base["nameRemark"] = "#{self.catalog_branch.abreviacion} COMB #{self.fecha_inicio.strftime("%d")}-#{self.fecha_fin.strftime("%d")} #{ I18n.l(self.fecha_fin, format: '%B') }"
            hash_base["instrumentoDePago"] = self.catalog_vendor.instrumentopago
            hash_base["originador"] = @current_user.correo_combustibles
            hash_base["usuarioActualizacion"] = @current_user.correo_combustibles
            hash_base["idPrograma"] = self.id
            hash_base["fechaActualizacion"] = "1#{Time.zone.now.strftime("%y")}#{(Time.zone.now).strftime("%j")}"
            hash_base["horaActualizacion"] = Time.zone.now.strftime("%H%M%S")
            hash_base["estacionDeTrabajo"] = "WEB91a"
            hash_polizaInput["poliza"] = hash_poliza,hash_base
        else
            @poliza << hash_poliza
            hash_polizaInput["poliza"] = @poliza
        end


            @costos = VehicleConsumption.joins(:consumption).joins(:vehicle).where(consumptions: {id: self.id}).group("vehicles.catalog_area_id, consumptions.catalog_branch_id, vehicles.catalog_branch_id").select("sum(vehicle_consumptions.monto) as monto, sum(vehicle_consumptions.impuestos) as impuestos, consumptions.catalog_branch_id as cediscarga, vehicles.catalog_branch_id as cedisorigen, vehicles.catalog_area_id as catalog_area_id")
            @costos.each_with_index do |ac,index|

                #if @costos != []
                hash_asientoDeDiario = Hash.new 
                hash_asientoDeDiario["numeroLinea"] = "#{index+1}000"
                hash_asientoDeDiario["numeroBatch"] = "0"
                hash_asientoDeDiario["fechaLM"] = "1#{self.fecha_fin.strftime("%y")}#{(self.fecha_fin).strftime("%j")}"
                hash_asientoDeDiario["tipoBatch"] = "V"
                #hash_asientoDeDiario["compañia"] = self.vehicle_consumptions[0].vehicle.catalog_company.clave
                hash_asientoDeDiario["compañia"] = hash_poliza["compañia"]
                catalogo = CatalogArea.find_by(id: ac.catalog_area_id)
                #byebug
                if catalogo.descripcion == "Operaciones"
                    if catalogo == nil
                        @mensaje_error  = ["No se encontro un Área con los datos proporcionados, por favor revise la información. Folio: #{self.folio}"]
                        return [@mensaje_error,false]
                    end

                end
                if valuation
                    cedis_de_carga = CatalogBranch.find_by(id: ac.cediscarga)
                    if valuation.catalog_branch.catalog_company_id == cedis_de_carga.catalog_company_id
                        tasa_costo = ValuationsBranch.find_by(catalog_branch_id: cedis_de_carga.id, valuation_id: valuation.valuation.id)
                        if tasa_costo
                            hash_asientoDeDiario["numeroCuenta"] = tasa_costo.valuation.cuenta
                        else
                            @mensaje_error  = ["El cedis: #{cedis_de_carga.decripcion} no tiene asignada la tasa correspondiente al iva de la factura."]
                            return [@mensaje_error,false]
                        end
                    else
                        account_impact = AccountingImpact.find_by(catalog_branch_id: self.catalog_branch_id,  cuenta_contable: "Otros gastos",catalog_area_id:catalogo.id,status:true)#.select(:nombre)#    "01060102.6103.0101"
                        if account_impact == nil
                            @mensaje_error  = ["No se encontró el Numero de cuenta para el cedis: #{self.catalog_branch.decripcion} y área: #{catalogo.descripcion} para el concepto de combustible otros gastos, por favor revise la información. Folio: #{self.folio}"]
                            return [@mensaje_error,false] 
                        else
                            hash_asientoDeDiario["numeroCuenta"] = account_impact.nombre
                        end
                    end
                else
                    #@mensaje_error  = ["No se encontró el Numero de cuenta para el cedis: #{self.catalog_branch.decripcion} y área: #{catalogo.descripcion} para el concepto de combustible, por favor revise la información. Folio: #{self.folio}"]
                    @mensaje_error  = ["El cedis: #{self.catalog_branch.decripcion} no tiene asignada la tasa correspondiente al iva de la factura."]
                    return [@mensaje_error,false]
                end
                #------------------------------------------------------------------------------------
                #no se si esta bien estos campos
                hash_asientoDeDiario["modoDeCuenta"] = "2"
                hash_asientoDeDiario["subledger"] = self.catalog_vendor.clave
                hash_asientoDeDiario["subledgerType"] = "A"
                #---------------------------------------------------------------------------------------
                hash_asientoDeDiario["tipoLibro"] = "AA"
                hash_asientoDeDiario["periodoFiscal"] = "0"
                #hash_asientoDeDiario["sigloFiscal"] = "21"
                hash_asientoDeDiario["sigloFiscal"] = "20"
                hash_asientoDeDiario["añoFiscal"] = "0"
                hash_asientoDeDiario["moneda"] = "MXP"
                #monto_total = @costos.map{|x| x.monto}.inject(:+)
                #impuestos_total = @costos.map{|x| x.impuestos}.inject(:+)
                if self.es_detallado
                    bandera_impuesto = (ac.impuestos.to_f.ceil(2) / valor_iva).ceil(2)
                    if ((ac.monto.to_f - ac.impuestos) - bandera_impuesto) > 0
                        bandera_base_cero = true
                    end
                    #byebug
                    if bandera_base_cero == true
                        monto_total = (ac.impuestos.ceil(2) / valor_iva).ceil(2)
                        impuestos_total = ac.impuestos.to_f

                        impuesto_base_renglon = ac.impuestos.to_f
                        monto_base_renglon = ac.monto.to_f
                        impuesto_base_cero_renglon = ac.monto - monto_total
                        #if index == 0
                        #end
                        #impuestos_totales = impuestos_totales + ac.impuestos.to_f 
                        impuesto_base_cero = ((ac.monto.ceil(2) - ac.impuestos.ceil(2)) - monto_total).ceil(2)
                        imponible = monto_total.to_f
                        #byebug
                        #valor_diario_monto = (imponible.ceil(2)*100).ceil
                        valor_diario_monto = (((imponible.ceil(2) + impuesto_base_cero.ceil(2)).ceil(2)*100).ceil(2)).to_i
                        #byebug
                        acumulado_impuesto_base_cero += (impuesto_base_cero.round(2)*100).round
                        acumulado_monto_total_base_cero += (monto_total.round(2)*100).round
                        acumulado_imponible_base_cero += (valor_diario_monto.round(2)).round
                    else
                        monto_total = ac.monto.to_f
                        impuestos_total = ac.impuestos.to_f
                        #impuestos_totales = impuestos_totales + ac.impuestos.to_f 
                        imponible = (monto_total.to_f - impuestos_total.to_f)
                        valor_diario_monto = (((imponible.ceil(2)*100).ceil(2)).to_f).to_s
                        acumulado_impuesto += (impuestos_total.ceil(2)*100).ceil
                        acumulado_monto_total += (monto_total.ceil(2)*100).ceil
                        acumulado_imponible += (valor_diario_monto.ceil(2)).ceil
                    end
                else

                    division_mto_fact = (ac.monto / self.monto).ceil(2)
                    #base_cero_imp = self.impuestos.to_f.floor(2) / valor_iva

                    prorrat_imp = (division_mto_fact * self.impuestos).ceil(2)

                    bandera_impuesto = (self.impuestos.to_f.ceil(2) / valor_iva).ceil(2)

                    bandera_impuesto_renglon = prorrat_imp / valor_iva

                    prorrat_base_cero = (division_mto_fact * ((self.monto - self.impuestos) - bandera_impuesto))


                    if ((ac.monto.to_f - prorrat_imp) - bandera_impuesto) > 0
                        bandera_base_cero = true
                    end
                    #byebug
                    if bandera_base_cero == true
                        #prorrat_imp_linea = self.impuestos * (division_mto_fact)
                        monto_total = ac.monto - prorrat_imp
                        impuestos_total = prorrat_imp.to_f

                        impuesto_base_renglon = prorrat_imp.to_f
                        monto_base_renglon = prorrat_imp.to_f
                        impuesto_base_cero_renglon = prorrat_base_cero

                        impuesto_base_cero = prorrat_base_cero

                        imponible = monto_total.to_f

                        valor_diario_monto = ((imponible.ceil(2))*100).ceil
                        #byebug
                        acumulado_impuesto_base_cero += (impuesto_base_cero.ceil(2)*100).ceil
                        acumulado_monto_total_base_cero += (monto_total.ceil(2)*100).ceil
                        acumulado_imponible_base_cero += (valor_diario_monto.ceil(2)).ceil
                    else
                        monto_total = ac.monto - prorrat_imp
                        impuestos_total = prorrat_imp.to_f

                        #imponible = (monto_total.to_f - impuestos_total.to_f)
                        valor_diario_monto = (monto_total.ceil(2)*100).ceil
                        acumulado_impuesto += (impuestos_total.ceil(2)*100).ceil
                        acumulado_monto_total += (monto_total.ceil(2)*100).ceil
                        acumulado_imponible += (valor_diario_monto.ceil(2)).ceil
                    end
                end
                # imponible = (self.monto/1.16).round(2)
                #     if index == 0
                # valor_div = (valor_diario_monto.to_f/100)/(imponible_global.to_f/100).round(4)
                # valor_mult = (valor_div * base.round(2)).round(2)
                # monto_base = ((valor_diario_monto.to_f/100) - valor_mult).round(2)
                # hash_asientoDeDiario["monto"]  = (monto_base * 100).to_i
                #byebug
                    if (@costos.length - 1) == index
                        #monto_total = @costos.map{|x| x.monto}.inject(:+)
                        #byebug
                        if @asientoDeDiario.length > 0 
                            valor_bandera = valor_diario_monto + @asientoDeDiario.map{|x| x["monto"]}.inject(:+)
                        else
                            valor_bandera = valor_diario_monto
                        end
                        if bandera_base_cero == true
                            #byebug
                            resta_diario_monto =  ((((self.impuestos / valor_iva).ceil(2) * 100).ceil(2) + importes) - valor_bandera).to_f
                        else
                            resta_diario_monto = ((((self.impuestos / valor_iva).ceil(2) * 100).ceil(2)) - valor_bandera).to_f
                        end
                        if resta_diario_monto == 1
                            hash_asientoDeDiario["monto"] = valor_diario_monto + 1
                        elsif resta_diario_monto == -1 
                            hash_asientoDeDiario["monto"] = valor_diario_monto - 1
                        else
                            hash_asientoDeDiario["monto"] = valor_diario_monto
                        end
                    else
                        hash_asientoDeDiario["monto"] = valor_diario_monto
                    end
                    #  (imponible * 100).to_i #((self.monto * 0.8654)*100).to_i
                #     else
                #     hash_asientoDeDiario["monto"] = ((imponible * 0.16).round(2) *100).to_i#((self.monto - (self.monto * 0.8654))*100).to_i
                #     end

                hash_asientoDeDiario["explicacion"] = self.catalog_vendor.razonsocial.first(30) #"Servicios Gasolineros de Mexic"# //eeee
                if ac.cedisorigen == ac.cediscarga
                    hash_asientoDeDiario["observaciones"] = "#{self.catalog_branch.abreviacion} COMB #{self.fecha_inicio.strftime("%d")}-#{self.fecha_fin.strftime("%d")} #{ I18n.l(self.fecha_fin, format: '%B')}" # cambiar las 3 primeras letras del cedis comb se queda
                else
                    hash_asientoDeDiario["observaciones"] = "#{self.catalog_branch.catalog_company.abreviatura} #{self.catalog_branch.abreviacion} COMB #{self.fecha_inicio.strftime("%d")}-#{self.fecha_fin.strftime("%d")} #{ I18n.l(self.fecha_fin, format: '%B')}" # cambiar las 3 primeras letras del cedis comb se queda
                end
                hash_asientoDeDiario["numeroBeneficiario"] = self.catalog_vendor.clave # self.vehicle_consumptions[0].vehicle.catalog_company.clave
                #aun no esta
                hash_asientoDeDiario["factura"] = self.n_factura #""#"145525"
                #----------------------------------

                hash_asientoDeDiario["fechaFactura"] = "1#{self.fecha_fin.strftime("%y")}#{(self.fecha_fin).strftime("%j")}"
                hash_asientoDeDiario["fechaEfectiva"] = "1#{self.created_at.strftime("%y")}#{(self.created_at).strftime("%j")}"
                hash_asientoDeDiario["codigoMoneda"] = "D"
                hash_asientoDeDiario["originador"] = @current_user.correo_combustibles #sacar de usuario de correo verificar que sea gafi.com.mx si no DYENCALADA 
                hash_asientoDeDiario["usuarioActualizacion"] = @current_user.correo_combustibles #sacar de usuario de correo verificar que sea gafi.com.mx si no DYENCALADA 
                hash_asientoDeDiario["idPrograma"] = self.id
                hash_asientoDeDiario["fechaActualizacion"] = "1#{Time.zone.now.strftime("%y")}#{(Time.zone.now).strftime("%j")}"
                hash_asientoDeDiario["horaActualizacion"] = Time.zone.now.strftime("%H%M%S")
                hash_asientoDeDiario["estacionDeTrabajo"]  = "WEB91a"
                @asientoDeDiario <<hash_asientoDeDiario
                #byebug
            #end
        end


        
        hash_info_adicional["UUID"] = self.uuid
        @info_adicional << hash_info_adicional
        hash_polizaInput["asientoDeDiario"] = @asientoDeDiario
        hash_polizaInput["infoAdicional"] = @info_adicional
        @polizaInput << hash_polizaInput
        hash_principal["polizaInput"] = @polizaInput[0]
        @objeto_principal << hash_principal
        # comentar de aquí a...
        paremetro_nombre = Parameter.find_by(nombre:"Url Poliza JDE")
        url = URI(paremetro_nombre.valor_extendido)
        https = Net::HTTP.new(url.host, url.port);
        request = Net::HTTP::Put.new(url)
        request["Content-Type"] = "application/json"
        request["Accept"] = "application/json"
        request.body = @objeto_principal[0].to_json
        response = https.request(request)
        @json_parciado = []
        respuesta = JSON.parse response.body
        if respuesta[0].nil?
            @json_parciado.push(respuesta)
        else
            @json_parciado = respuesta
        end
        #byebug
        JdeLog.create(
            fecha: Time.zone.now.to_date,
            hora: Time.zone.now,
            json_enviado: @objeto_principal,
            respuesta: @json_parciado
        )
            
        if @json_parciado.map{|x| x['Exitoso']}.include?(false) 
            #return [@json_parciado,false]
            enviar_json_comb_dos(@current_user)
        else
            return [@json_parciado,true]
        end

        

        # aquí, para no  enviar  el json a JDE
        #return[@objeto_principal,true]   #descomentar este return para que ver el json que se esta mandando a JDE
    end

    def enviar_json_comb_dos(current_user)
        @current_user = current_user
        @objeto_principal = []
        @polizaInput = []
        @poliza = []
        @base = []
        @asientoDeDiario = []
        @info_adicional = []
        impuestos_totales = 0
        hash_principal = Hash.new
        hash_polizaInput = Hash.new
        hash_poliza = Hash.new
        hash_base = Hash.new
        hash_info_adicional = Hash.new
        hash_poliza["usuario"] = @current_user.correo_combustibles
        hash_poliza["numeroTransaccion"] = "1"
        hash_poliza["numeroLinea"] = "1000"
        hash_poliza["numeroBatch"] = "0"
        cat_company = CatalogCompany.find_by(id: self.company_id)
        hash_poliza["compañiaDocumento"] = cat_company.clave
        #hash_poliza["compañiaDocumento"] = "00001"
        hash_poliza["tipoDocumento"] = "PV"
        hash_poliza["numeroProveedor"] = self.catalog_vendor.clave #"49965"#self.vehicle_consumptions[0].vehicle.catalog_company.clave    sacar de la relacion
        hash_poliza["numeroBeneficiario"] = self.catalog_vendor.clave  #"49965"#self.vehicle_consumptions[0].vehicle.catalog_company.clave  sacar de la relacion con proveedor numero de (proveedor)
        hash_poliza["fechaFactura"] = "1#{self.fecha_factura.strftime("%y")}#{(self.fecha_factura).strftime("%j")}"
        hash_poliza["fechaEfectiva"] = "1#{self.created_at.strftime("%y")}#{(self.created_at).strftime("%j")}"
        hash_poliza["fechaVencimiento"] = "" #"120252" 
        hash_poliza["fechaDescuento"] = "1#{self.fecha_factura.strftime("%y")}#{(self.fecha_factura).strftime("%j")}" #"120252"
        hash_poliza["fechaLM"] = "1#{self.fecha_aplicacion.strftime("%y")}#{(self.fecha_aplicacion).strftime("%j")}"
        hash_poliza["añoFiscal"] = "0"
        #hash_poliza["sigloFiscal"] = "21"
        hash_poliza["sigloFiscal"] = "20"
        hash_poliza["periodoFiscal"] = "0"
        hash_poliza["compañia"] = self.vehicle_consumptions[0].vehicle.catalog_company.clave#"DYENCALADA"
        hash_poliza["tipoBatch"] = "V"
        hash_poliza["transaccionBalanceada"] = "Y"
        hash_poliza["estatusDePago"] = "H"
        valuation = ValuationsBranch.find_by(catalog_vendor_id: self.catalog_vendor_id, catalog_branch_id: self.catalog_branch_id)
        if valuation
            valor_iva = valuation.valuation.valor / 100
        else
            valor_iva = 0.16
        end
        #imponible = (self.monto.to_f - self.impuestos.to_f).round(2)
        #byebug
        imponible = (self.impuestos.to_f / valor_iva)
        imponible_global = ((imponible) * 100).to_i

        acumulado_impuesto_base_cero = 0
        acumulado_monto_total_base_cero = 0
        acumulado_imponible_base_cero = 0
        acumulado_impuesto = 0
        acumulado_monto_total = 0
        acumulado_imponible = 0


        bandera_base_cero = false
        bandera_impuesto = (self.impuestos.ceil(2) / valor_iva).ceil(2)
        if ((self.monto - self.impuestos).ceil(2) - bandera_impuesto) > 0
            bandera_base_cero = true
        end
        valor_importe_global = (((self.impuestos / valor_iva).ceil(2) * (1 + valor_iva)).ceil(2) * 100).ceil(2)
        hash_poliza["importe"] = (valor_importe_global.to_f).to_i
        hash_poliza["importePendiente"] = (valor_importe_global.to_f).to_i
        hash_poliza["importeImponible"] = ((self.impuestos / valor_iva).ceil(2) * 100).ceil(2).to_i

        hash_poliza["importeImpuesto"] = (self.impuestos.to_f.floor(2)* 100).ceil
        hash_poliza["tasaFiscal"] = "IVA15GAS"
        hash_poliza["explicacionFiscal"] = "V"
        hash_poliza["tipoMoneda"] = "D"
        hash_poliza["moneda"] = "MXP"
        hash_poliza["glClass"] = self.catalog_vendor.compenlm
        #hash_poliza["cuentaBancaria"] = "00000000" #sacar de vendors -------------------------------------- la agarre de vendors
        #hash_poliza["cuentaBancaria"] = ""
        hash_poliza["modoDeCuenta"] = "2"
        #hash_poliza["unidadDeNegocio"] = self.catalog_branch.unidad_negocio
        area_mayor = nil
        bandera_total = 0
        CatalogArea.all.each do |area|
            cuenta = self.vehicle_consumptions.joins(:vehicle).where(vehicles: {catalog_area_id: area.id}).count
            if cuenta > 0
                suma = self.vehicle_consumptions.joins(:vehicle).where(vehicles: {catalog_area_id: area.id}).sum(:monto)
                if suma > bandera_total
                    bandera_total = suma
                    area_mayor = area.clave
                end
            end
        end
        #hash_poliza["unidadDeNegocio"] = "09990706"
        hash_poliza["unidadDeNegocio"] = "#{self.catalog_branch.unidad_negocio}#{area_mayor}"
        #byebug
        hash_poliza["plazo"] = self.catalog_vendor.plazo #sacar de vendors -----------------------------------------
        hash_poliza["factura"] = self.n_factura # "145525"#self.n_factura
        hash_poliza["nameRemark"] = "#{self.catalog_branch.abreviacion} COMB #{self.fecha_inicio.strftime("%d")}-#{self.fecha_fin.strftime("%d")} #{ I18n.l(self.fecha_fin, format: '%B') }"
        hash_poliza["instrumentoDePago"] = self.catalog_vendor.instrumentopago
        hash_poliza["originador"] = @current_user.correo_combustibles
        hash_poliza["usuarioActualizacion"] = @current_user.correo_combustibles
        hash_poliza["idPrograma"] = self.id
        hash_poliza["fechaActualizacion"] = "1#{Time.zone.now.strftime("%y")}#{(Time.zone.now).strftime("%j")}" #"1#{self.updated_at.strftime("%y")}#{(self.updated_at).strftime("%j")}"
        hash_poliza["horaActualizacion"] = Time.zone.now.strftime("%H%M%S")
        hash_poliza["estacionDeTrabajo"] = "WEB91a"


        if bandera_base_cero == true
            hash_base["usuario"] = @current_user.correo_combustibles
            hash_base["numeroTransaccion"] = "1"
            hash_base["numeroLinea"] = "2000"
            hash_base["numeroBatch"] = "0"
            hash_base["compañiaDocumento"] = "00001"
            hash_base["tipoDocumento"] = "PV"
            hash_base["numeroProveedor"] = self.catalog_vendor.clave#"49965"#self.vehicle_consumptions[0].vehicle.catalog_company.clave    sacar de la relacion
            hash_base["numeroBeneficiario"] = self.catalog_vendor.clave #"49965"#self.vehicle_consumptions[0].vehicle.catalog_company.clave  sacar de la relacion con proveedor numero de (proveedor)
            hash_base["fechaFactura"] = "1#{self.fecha_factura.strftime("%y")}#{(self.fecha_factura).strftime("%j")}"
            hash_base["fechaEfectiva"] = "1#{self.created_at.strftime("%y")}#{(self.created_at).strftime("%j")}"
            hash_base["fechaVencimiento"] = "" #"120252" 
            hash_base["fechaDescuento"] = "1#{self.fecha_factura.strftime("%y")}#{(self.fecha_factura).strftime("%j")}" #"120252"
            hash_base["fechaLM"] = "1#{self.fecha_aplicacion.strftime("%y")}#{(self.fecha_aplicacion).strftime("%j")}"
            hash_base["añoFiscal"] = "0"
            hash_base["sigloFiscal"] = "20"
            hash_base["periodoFiscal"] = "0"
            hash_base["compañia"] = self.vehicle_consumptions[0].vehicle.catalog_company.clave#"DYENCALADA"
            hash_base["tipoBatch"] = "V"
            hash_base["transaccionBalanceada"] = "Y"
            hash_base["estatusDePago"] = "H"
            importes = (((self.monto - self.impuestos).ceil(2) - bandera_impuesto) * 100).ceil
            hash_base["importe"] =  importes
            hash_base["importePendiente"] =   importes 
            hash_base["importeImponible"] =  importes
            hash_base["importeImpuesto"] = "0"
            hash_base["tasaFiscal"] = "IVA0GAS"
            hash_base["explicacionFiscal"] = "V"
            hash_base["tipoMoneda"] = "D"
            hash_base["moneda"] = "MXP"
            hash_base["glClass"] = self.catalog_vendor.compenlm
            hash_base["modoDeCuenta"] = "2"
            hash_base["unidadDeNegocio"] = "#{self.catalog_branch.unidad_negocio}#{area_mayor}"
            hash_base["plazo"] = self.catalog_vendor.plazo
            hash_base["factura"] = self.n_factura 
            hash_base["nameRemark"] = "#{self.catalog_branch.abreviacion} COMB #{self.fecha_inicio.strftime("%d")}-#{self.fecha_fin.strftime("%d")} #{ I18n.l(self.fecha_fin, format: '%B') }"
            hash_base["instrumentoDePago"] = self.catalog_vendor.instrumentopago
            hash_base["originador"] = @current_user.correo_combustibles
            hash_base["usuarioActualizacion"] = @current_user.correo_combustibles
            hash_base["idPrograma"] = self.id
            hash_base["fechaActualizacion"] = "1#{Time.zone.now.strftime("%y")}#{(Time.zone.now).strftime("%j")}"
            hash_base["horaActualizacion"] = Time.zone.now.strftime("%H%M%S")
            hash_base["estacionDeTrabajo"] = "WEB91a"
            hash_polizaInput["poliza"] = hash_poliza,hash_base
        else
            @poliza << hash_poliza
            hash_polizaInput["poliza"] = @poliza
        end

            @costos = VehicleConsumption.joins(:consumption).joins(:vehicle).where(consumptions: {id: self.id}).group("vehicles.catalog_area_id, consumptions.catalog_branch_id, vehicles.catalog_branch_id").select("sum(vehicle_consumptions.monto) as monto, sum(vehicle_consumptions.impuestos) as impuestos, consumptions.catalog_branch_id as cediscarga, vehicles.catalog_branch_id as cedisorigen, vehicles.catalog_area_id as catalog_area_id")
            @costos.each_with_index do |ac,index|

                #if @costos != []
                hash_asientoDeDiario = Hash.new 
                hash_asientoDeDiario["numeroLinea"] = "#{index+1}000"
                hash_asientoDeDiario["numeroBatch"] = "0"
                hash_asientoDeDiario["fechaLM"] = "1#{self.fecha_fin.strftime("%y")}#{(self.fecha_fin).strftime("%j")}"
                hash_asientoDeDiario["tipoBatch"] = "V"
                #hash_asientoDeDiario["compañia"] = self.vehicle_consumptions[0].vehicle.catalog_company.clave
                hash_asientoDeDiario["compañia"] = hash_poliza["compañia"]
                catalogo = CatalogArea.find_by(id: ac.catalog_area_id)
                #byebug
                if catalogo.descripcion == "Operaciones"
                    if catalogo == nil
                        @mensaje_error  = ["No se encontro un Área con los datos proporcionados, por favor revise la información. Folio: #{self.folio}"]
                        return [@mensaje_error,false]
                    end

                end
                if valuation
                    cedis_de_carga = CatalogBranch.find_by(id: ac.cediscarga)
                    if valuation.catalog_branch.catalog_company_id == cedis_de_carga.catalog_company_id
                        tasa_costo = ValuationsBranch.find_by(catalog_branch_id: cedis_de_carga.id, valuation_id: valuation.valuation.id)
                        if tasa_costo
                            hash_asientoDeDiario["numeroCuenta"] = tasa_costo.valuation.cuenta
                        else
                            @mensaje_error  = ["El cedis: #{cedis_de_carga.decripcion} no tiene asignada la tasa correspondiente al iva de la factura."]
                            return [@mensaje_error,false]
                        end
                    else
                        account_impact = AccountingImpact.find_by(catalog_branch_id: self.catalog_branch_id,  cuenta_contable: "Otros gastos",catalog_area_id:catalogo.id,status:true)#.select(:nombre)#    "01060102.6103.0101"
                        if account_impact == nil
                            @mensaje_error  = ["No se encontró el Numero de cuenta para el cedis: #{self.catalog_branch.decripcion} y área: #{catalogo.descripcion} para el concepto de combustible otros gastos, por favor revise la información. Folio: #{self.folio}"]
                            return [@mensaje_error,false] 
                        else
                            hash_asientoDeDiario["numeroCuenta"] = account_impact.nombre
                        end
                    end
                else
                    #@mensaje_error  = ["No se encontró el Numero de cuenta para el cedis: #{self.catalog_branch.decripcion} y área: #{catalogo.descripcion} para el concepto de combustible, por favor revise la información. Folio: #{self.folio}"]
                    @mensaje_error  = ["El cedis: #{self.catalog_branch.decripcion} no tiene asignada la tasa correspondiente al iva de la factura."]
                    return [@mensaje_error,false]
                end
                #------------------------------------------------------------------------------------
                #no se si esta bien estos campos
                hash_asientoDeDiario["modoDeCuenta"] = "2"
                hash_asientoDeDiario["subledger"] = self.catalog_vendor.clave
                hash_asientoDeDiario["subledgerType"] = "A"
                #---------------------------------------------------------------------------------------
                hash_asientoDeDiario["tipoLibro"] = "AA"
                hash_asientoDeDiario["periodoFiscal"] = "0"
                #hash_asientoDeDiario["sigloFiscal"] = "21"
                hash_asientoDeDiario["sigloFiscal"] = "20"
                hash_asientoDeDiario["añoFiscal"] = "0"
                hash_asientoDeDiario["moneda"] = "MXP"
                #monto_total = @costos.map{|x| x.monto}.inject(:+)
                #impuestos_total = @costos.map{|x| x.impuestos}.inject(:+)
                if self.es_detallado
                    bandera_impuesto = (ac.impuestos.to_f.round(2) / valor_iva).round(2)
                    if ((ac.monto.to_f - ac.impuestos) - bandera_impuesto) > 0
                        bandera_base_cero = true
                    end
                    #byebug
                    if bandera_base_cero == true
                        monto_total = (ac.impuestos.ceil(2) / valor_iva).ceil(2)
                        impuestos_total = ac.impuestos.to_f

                        impuesto_base_renglon = ac.impuestos.to_f
                        monto_base_renglon = ac.monto.to_f
                        impuesto_base_cero_renglon = ac.monto - monto_total
                        #if index == 0
                        #end
                        #impuestos_totales = impuestos_totales + ac.impuestos.to_f 
                        impuesto_base_cero = ((ac.monto.ceil(2) - ac.impuestos.ceil(2)) - monto_total).ceil(2)
                        imponible = monto_total.to_f
                        #byebug
                        #valor_diario_monto = (imponible.ceil(2)*100).ceil
                        valor_diario_monto = (((imponible.ceil(2) + impuesto_base_cero.ceil(2)).ceil(2)*100).ceil(2)).to_i
                        #byebug
                        acumulado_impuesto_base_cero += (impuesto_base_cero.round(2)*100).round
                        acumulado_monto_total_base_cero += (monto_total.round(2)*100).round
                        acumulado_imponible_base_cero += (valor_diario_monto.round(2)).round
                    else
                        monto_total = ac.monto.to_f
                        impuestos_total = ac.impuestos.to_f
                        #impuestos_totales = impuestos_totales + ac.impuestos.to_f 
                        imponible = (monto_total.to_f - impuestos_total.to_f)
                        valor_diario_monto = (((imponible.round(2)*100).round(2)).to_f).to_s
                        acumulado_impuesto += (impuestos_total.round(2)*100).round
                        acumulado_monto_total += (monto_total.round(2)*100).round
                        acumulado_imponible += (valor_diario_monto.round(2)).round
                    end
                else

                    division_mto_fact = (ac.monto / self.monto).round(2)
                    #base_cero_imp = self.impuestos.to_f.floor(2) / valor_iva

                    prorrat_imp = (division_mto_fact * self.impuestos).round(2)

                    bandera_impuesto = (self.impuestos.to_f.round(2) / valor_iva).round(2)

                    bandera_impuesto_renglon = prorrat_imp / valor_iva

                    prorrat_base_cero = (division_mto_fact * ((self.monto - self.impuestos) - bandera_impuesto))


                    if ((ac.monto.to_f - prorrat_imp) - bandera_impuesto) > 0
                        bandera_base_cero = true
                    end
                    #byebug
                    if bandera_base_cero == true
                        #prorrat_imp_linea = self.impuestos * (division_mto_fact)
                        monto_total = ac.monto - prorrat_imp
                        impuestos_total = prorrat_imp.to_f

                        impuesto_base_renglon = prorrat_imp.to_f
                        monto_base_renglon = prorrat_imp.to_f
                        impuesto_base_cero_renglon = prorrat_base_cero

                        impuesto_base_cero = prorrat_base_cero

                        imponible = monto_total.to_f

                        valor_diario_monto = ((imponible.round(2))*100).round
                        #byebug
                        acumulado_impuesto_base_cero += (impuesto_base_cero.round(2)*100).round
                        acumulado_monto_total_base_cero += (monto_total.round(2)*100).round
                        acumulado_imponible_base_cero += (valor_diario_monto.round(2)).round
                    else
                        monto_total = ac.monto - prorrat_imp
                        impuestos_total = prorrat_imp.to_f

                        #imponible = (monto_total.to_f - impuestos_total.to_f)
                        valor_diario_monto = (monto_total.round(2)*100).round
                        acumulado_impuesto += (impuestos_total.round(2)*100).round
                        acumulado_monto_total += (monto_total.round(2)*100).round
                        acumulado_imponible += (valor_diario_monto.round(2)).round
                    end
                end
                # imponible = (self.monto/1.16).round(2)
                #     if index == 0
                # valor_div = (valor_diario_monto.to_f/100)/(imponible_global.to_f/100).round(4)
                # valor_mult = (valor_div * base.round(2)).round(2)
                # monto_base = ((valor_diario_monto.to_f/100) - valor_mult).round(2)
                # hash_asientoDeDiario["monto"]  = (monto_base * 100).to_i
                #byebug
                    if (@costos.length - 1) == index
                        #monto_total = @costos.map{|x| x.monto}.inject(:+)
                        #byebug
                        if @asientoDeDiario.length > 0 
                            valor_bandera = valor_diario_monto + @asientoDeDiario.map{|x| x["monto"]}.inject(:+)
                        else
                            valor_bandera = valor_diario_monto
                        end
                        #byebug
                        if bandera_base_cero == true
                            #byebug
                            resta_diario_monto =  ((((self.impuestos / valor_iva).ceil(2) * 100).ceil(2) + importes) - valor_bandera).to_f
                        else
                            resta_diario_monto = ((((self.impuestos / valor_iva).ceil(2) * 100).ceil(2)) - valor_bandera).to_f
                        end
                        # if resta_diario_monto == 1
                        #     hash_asientoDeDiario["monto"] = valor_diario_monto + 1
                        # elsif resta_diario_monto == -1 
                        #     hash_asientoDeDiario["monto"] = valor_diario_monto - 1
                        # else
                        #     hash_asientoDeDiario["monto"] = valor_diario_monto
                        # end
                        #byebug
                        if resta_diario_monto > 0.0
                            hash_asientoDeDiario["monto"] = (valor_diario_monto + resta_diario_monto).to_i
                        elsif resta_diario_monto < 0.0 
                            hash_asientoDeDiario["monto"] = (valor_diario_monto + resta_diario_monto).to_i
                        else
                            hash_asientoDeDiario["monto"] = valor_diario_monto
                        end
                    else
                        hash_asientoDeDiario["monto"] = valor_diario_monto
                    end
                    #  (imponible * 100).to_i #((self.monto * 0.8654)*100).to_i
                #     else
                #     hash_asientoDeDiario["monto"] = ((imponible * 0.16).round(2) *100).to_i#((self.monto - (self.monto * 0.8654))*100).to_i
                #     end

                hash_asientoDeDiario["explicacion"] = self.catalog_vendor.razonsocial.first(30) #"Servicios Gasolineros de Mexic"# //eeee
                if ac.cedisorigen == ac.cediscarga
                    hash_asientoDeDiario["observaciones"] = "#{self.catalog_branch.abreviacion} COMB #{self.fecha_inicio.strftime("%d")}-#{self.fecha_fin.strftime("%d")} #{ I18n.l(self.fecha_fin, format: '%B')}" # cambiar las 3 primeras letras del cedis comb se queda
                else
                    hash_asientoDeDiario["observaciones"] = "#{self.catalog_branch.catalog_company.abreviatura} #{self.catalog_branch.abreviacion} COMB #{self.fecha_inicio.strftime("%d")}-#{self.fecha_fin.strftime("%d")} #{ I18n.l(self.fecha_fin, format: '%B')}" # cambiar las 3 primeras letras del cedis comb se queda
                end
                hash_asientoDeDiario["numeroBeneficiario"] = self.catalog_vendor.clave # self.vehicle_consumptions[0].vehicle.catalog_company.clave
                #aun no esta
                hash_asientoDeDiario["factura"] = self.n_factura #""#"145525"
                #----------------------------------

                hash_asientoDeDiario["fechaFactura"] = "1#{self.fecha_fin.strftime("%y")}#{(self.fecha_fin).strftime("%j")}"
                hash_asientoDeDiario["fechaEfectiva"] = "1#{self.created_at.strftime("%y")}#{(self.created_at).strftime("%j")}"
                hash_asientoDeDiario["codigoMoneda"] = "D"
                hash_asientoDeDiario["originador"] = @current_user.correo_combustibles #sacar de usuario de correo verificar que sea gafi.com.mx si no DYENCALADA 
                hash_asientoDeDiario["usuarioActualizacion"] = @current_user.correo_combustibles #sacar de usuario de correo verificar que sea gafi.com.mx si no DYENCALADA 
                hash_asientoDeDiario["idPrograma"] = self.id
                hash_asientoDeDiario["fechaActualizacion"] = "1#{Time.zone.now.strftime("%y")}#{(Time.zone.now).strftime("%j")}"
                hash_asientoDeDiario["horaActualizacion"] = Time.zone.now.strftime("%H%M%S")
                hash_asientoDeDiario["estacionDeTrabajo"]  = "WEB91a"
                @asientoDeDiario <<hash_asientoDeDiario
                #byebug
            #end
        end


        
        hash_info_adicional["UUID"] = self.uuid
        @info_adicional << hash_info_adicional
        hash_polizaInput["asientoDeDiario"] = @asientoDeDiario
        hash_polizaInput["infoAdicional"] = @info_adicional
        @polizaInput << hash_polizaInput
        hash_principal["polizaInput"] = @polizaInput[0]
        @objeto_principal << hash_principal
        # comentar de aquí a...
        paremetro_nombre = Parameter.find_by(nombre:"Url Poliza JDE")
        url = URI(paremetro_nombre.valor_extendido)
        https = Net::HTTP.new(url.host, url.port);
        request = Net::HTTP::Put.new(url)
        request["Content-Type"] = "application/json"
        request["Accept"] = "application/json"
        request.body = @objeto_principal[0].to_json
        response = https.request(request)
        @json_parciado = []
        respuesta = JSON.parse response.body
        if respuesta[0].nil?
            @json_parciado.push(respuesta)
        else
            @json_parciado = respuesta
        end
        #byebug
        JdeLog.create(
            fecha: Time.zone.now.to_date,
            hora: Time.zone.now,
            json_enviado: @objeto_principal,
            respuesta: @json_parciado
        )
            
        if @json_parciado.map{|x| x['Exitoso']}.include?(false) 
            #enviar_json_redondeado(@current_user)
            return [@json_parciado,false]
        else
            return [@json_parciado,true]
        end

        

        # aquí, para no  enviar  el json a JDE
        #return[@objeto_principal,true]   #descomentar este return para que ver el json que se esta mandando a JDE
    end    
    
    def self.crear_pdf(params, encabezado)
        bandera_error = 0
        mensaje = ""
        busqueda_enc = Consumption.find_by(id: encabezado)
        begin
            if busqueda_enc
                if busqueda_enc.update(pdf: params[:consumption][:pdf])
                    bandera_error = 4
                    mensaje = "Documento agregado correctamente."                
                else
                    documento.errors.full_messages.each do |error|
                        mensaje += " #{error}."
                    end
                    bandera_error = 3
                end
            else
                bandera_error = 1
                mensaje = "No se encontró el registro del encabezado."
            end
        rescue Exception => error
            mensaje = error
            bandera_error = 3
        end
        return mensaje,bandera_error
    end
end
