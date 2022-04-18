class Vehicle < ApplicationRecord
  include ActionView::Helpers::NumberHelper
  belongs_to :catalog_company,optional: true
  belongs_to :catalog_branch,optional: true
  belongs_to :cost_center,optional: true
  belongs_to :responsable,optional: true
  belongs_to :vehicle_status,optional: true
  belongs_to :vehicle_type,optional: true
  belongs_to :catalog_brand,optional: true
  belongs_to :catalog_model,optional: true
  belongs_to :billed_company,optional: true
  belongs_to :catalog_route,optional: true
  belongs_to :policy_coverage,optional: true
  belongs_to :insurance_beneficiary,optional: true
  belongs_to :plate_state,optional: true
  belongs_to :catalog_area,optional: true
  belongs_to :catalog_personal,optional: true
  belongs_to :purchase_order,optional: true
  has_many :maintenance_logs
  has_many :vehicle_adaptations
  has_many :user_vehicles
  has_many :catalog_licences
  has_many :vehicle_permits
  has_many :fuel_budgets
  has_many :vehicle_consumptions
  has_many :maintenance_controls
  has_many :monthly_yields
  has_many :maintenance_appointment
  has_many :sales
  has_many :approximate_costs
  has_many :maintenance_frecuency
  has_many :service_orders
  has_one_attached :file
  has_one_attached :foto
  has_one_attached :siniestrado
  has_one_attached :factura
  has_one_attached :aseguradora
  has_one_attached :federal
  has_one_attached :mecanico
  has_one_attached :ambiental
  validates :numero_economico, uniqueness: true
  has_many :vehicle_logs
  after_create :log_crear
  before_update :log_actualizar

  has_one :maintenance_program

  belongs_to :permission_type, optional: true
  belongs_to :vehicle_configuration, optional: true
  belongs_to :trailer_subtype, optional: true
  belongs_to :warehouse, optional: true

  def self.listado_vehiculos
    Vehicle.where.not(vehicle_status_id: ["3", "8"]).order(numero_economico: :asc)
  end

  def self.to_csv(options = {})
    CSV.generate(options) do |csv|
      csv << column_names
      all.each do |vehicle|
        csv << vehicle.attributes.values_at(*column_names)
      end
    end
  end

  def nombre_p_vehiculo
    "#{self.numero_economico}.- #{self.catalog_brand_id ? self.catalog_brand.descripcion : "N/A"}"
  end

  def kilometraje_actual
    kilometrajes = MileageIndicator.where(vehicle_id: self.id).order(fecha: :desc)
    if kilometrajes.length > 0
      return kilometrajes.first.km_actual
    else
      return 0
    end
  end
  
  def gasto_kilometro_ano_curso
    control = MaintenanceControl.where("vehicle_id =#{self.id} and año ='#{Time.zone.now.year}'").sum(:importe)
    programa = MaintenanceProgram.find_by(vehicle_id: self.id)
    if programa
      return control/programa.km_recorrido_curso
    else
      return 0
    end
  end

  def kilometro_inicio_ano_curso
    programa = MaintenanceProgram.find_by(vehicle_id: self.id)
    if programa
      return programa.km_inicio_ano
    else
      return 0
    end
  end

  def kilometro_recorrido_ano_curso
    programa = MaintenanceProgram.find_by(vehicle_id: self.id)
    if programa
      return programa.km_recorrido_curso
    else
      return 0
    end
  end

  def self.import_vehicles(file)
    spreadsheet = Roo::Spreadsheet.open(file.path)
    arreglo_vehiculos = Array.new()
    header = spreadsheet.sheet('Importar maestro').row(1)
    header_placas = spreadsheet.sheet('Importar placas').row(1)
    header_polizas = spreadsheet.sheet('Importar pólizas').row(1)
    header_fisicos = spreadsheet.sheet('Importar permisos fisicos').row(1)
    header_ambiental = spreadsheet.sheet('Importar permisos ambiental').row(1)

    if spreadsheet.sheet('Importar maestro').count > 1
      (2..spreadsheet.sheet('Importar maestro').last_row).each do |i|
          row = Hash[[header, spreadsheet.sheet('Importar maestro').row(i)].transpose]
          hash_vehiculo = Hash.new
  
          if row["Centro de distribución"]
            #quita los espacios en blanco al incio y al final
            em = row["Empresa"].to_s.strip
            ced = row["Centro de distribución"].to_s.strip
            cen = row["Centro de costos"].to_s.strip
            res = row["Responsable"].to_s.strip
            es = row["Estatus"].to_s.strip
            tv = row["Tipo de vehículo"].to_s.strip
            ln = row["Linea"].to_s.strip
            mod = row["Modelo"].to_s.strip
            emf = row["Empresa facturable"].to_s.strip
            cob = row["Cobertura"].to_s.strip
            bn = row["Beneficiario"].to_s.strip
            esp = row["Estado plaqueo"].to_s.strip
            ar = row["Area"].to_s.strip
            rut= row["Ruta"].to_s.strip
            us = row["Usuario"].to_s.strip
            no = row["Numero economico"].to_s
            b_vehiculo = Vehicle.find_by(numero_economico: no)
            compania = CatalogCompany.find_by(nombre: em)
            cedis = CatalogBranch.find_by(decripcion: ced)
            centro = CostCenter.find_by(descripcion: cen)
            responsable = Responsable.find_by(nombre: res)
            status = VehicleStatus.find_by(descripcion: es)
            tipo = VehicleType.find_by(descripcion: tv)
            linea = CatalogBrand.find_by(descripcion: ln)
            modelo = CatalogModel.find_by(descripcion: mod)
            empresaf = BilledCompany.find_by(nombre: emf)
            cobertura = PolicyCoverage.find_by(descripcion: cob)
            beneficiario = InsuranceBeneficiary.find_by(descripcion: bn)
            estado = PlateState.find_by(descripcion: esp)
            area = CatalogArea.find_by(descripcion: ar)
            ruta = CatalogRoute.find_by(descripcion: rut)
            usuario = CatalogPersonal.find_by(nombre: us)
            #byebug
            #validacion para campos foraneos
            if !compania
              hash_vehiculo["Problema"] = "La empresa #{row["Empresa"]} no se encuentra registrado en el catálogo de empresas, verifique por favor..."
              hash_vehiculo["fila"] = i
              arreglo_vehiculos.push(hash_vehiculo)
              next
           end
            if !cedis
              hash_vehiculo["Problema"] = "El CEDIS #{row["Centro de distribución"]} no se encuentra registrado en el catálogo de sucursales, verifique por favor..."
              hash_vehiculo["fila"] = i
              arreglo_vehiculos.push(hash_vehiculo)
              next
            end
            if !centro
              hash_vehiculo["Problema"] = "El centro de costo #{row["Centro de costos"]} no se encuentra registrado en el catálogo de sucursales, verifique por favor..."
              hash_vehiculo["fila"] = i
              arreglo_vehiculos.push(hash_vehiculo)
              next
          end
            if !responsable
              hash_vehiculo["Problema"] = "El responsable #{row["Responsable"]} no se encuentra registrado en el catálogo de responsables, verifique por favor..."
              hash_vehiculo["fila"] = i
              arreglo_vehiculos.push(hash_vehiculo)
              next
          end
          if !status
            hash_vehiculo["Problema"] = "El estatus #{row["Estatus"]} no se encuentra registrado en el catálogo de estatus, verifique por favor..."
            hash_vehiculo["fila"] = i
            arreglo_vehiculos.push(hash_vehiculo)
            next
          end
          if !tipo
            hash_vehiculo["Problema"] = "El tipo de vehículo #{row["Tipo de vehículo"]} no se encuentra registrado en el catálogo de tipos de vehículos, verifique por favor..."
            hash_vehiculo["fila"] = i
            arreglo_vehiculos.push(hash_vehiculo)
            next
          end
          if !linea
          hash_vehiculo["Problema"] = "La #{row["Linea"]} no se encuentra registrado en el catálogo de linea, verifique por favor..."
          hash_vehiculo["fila"] = i
          arreglo_vehiculos.push(hash_vehiculo)
            next
          end
          if !modelo
            hash_vehiculo["Problema"] = "El modelo #{row["Modelo"]} no se encuentra registrado en el catálogo de modelos, verifique por favor..."
            hash_vehiculo["fila"] = i
            arreglo_vehiculos.push(hash_vehiculo)
            next
          end
          if !empresaf
          hash_vehiculo["Problema"] = "La empresa facturable #{row["Empresa facturable"]} no se encuentra registrado en el catálogo de empresas facturables, verifique por favor..."
          hash_vehiculo["fila"] = i
          arreglo_vehiculos.push(hash_vehiculo)
            next
          end
          if !cobertura
            hash_vehiculo["Problema"] = "La cobertura #{row["Cobertura"]} no se encuentra registrado en el catálogo de coberturas de polizas, verifique por favor..."
            hash_vehiculo["fila"] = i
            arreglo_vehiculos.push(hash_vehiculo)
              next
          end
          if !beneficiario
            hash_vehiculo["Problema"] = "El beneficiario #{row["Beneficiario"]} no se encuentra registrado en el catálogo de beneficiario preferente, verifique por favor..."
            hash_vehiculo["fila"] = i
            arreglo_vehiculos.push(hash_vehiculo)
              next
          end
          if !estado
            hash_vehiculo["Problema"] = "El estado de plaqueo #{row["Estado plaqueo"]} no se encuentra registrado en el catálogo de estado de plaqueo, verifique por favor..."
            hash_vehiculo["fila"] = i
            arreglo_vehiculos.push(hash_vehiculo)
              next
          end
          if !area
            hash_vehiculo["Problema"] = "El área #{row["Area"]} no se encuentra registrado en el catálogo de areas, verifique por favor..."
            hash_vehiculo["fila"] = i
            arreglo_vehiculos.push(hash_vehiculo)
              next
          end
          if !ruta
            hash_vehiculo["Problema"] = "La ruta#{row["Ruta"]} no se encuentra registrado en el catálogo de rutas, verifique por favor..."
            hash_vehiculo["fila"] = i
            arreglo_vehiculos.push(hash_vehiculo)
              next
          end
          if !usuario
            hash_vehiculo["Problema"] = "El usuario #{row["Usuario"]} no se encuentra registrado en el catálogo de personal, verifique por favor..."
            hash_vehiculo["fila"] = i
            arreglo_vehiculos.push(hash_vehiculo)
            next
         end
         begin
          #si encuentra un vehiculo lo actualiza
               if b_vehiculo
                store_vehicles = b_vehiculo.update(numero_economico:row["Numero economico"],catalog_company_id:compania.id,catalog_branch_id:cedis.id,cost_center_id:centro.id,responsable_id:responsable.id,vehicle_status_id:status.id, vehicle_type_id:tipo.id, catalog_brand_id:linea.id, catalog_model_id:modelo.id,billed_company_id:empresaf.id,policy_coverage_id:cobertura.id,insurance_beneficiary_id:beneficiario.id,plate_state_id:estado.id,catalog_area_id:area.id,catalog_route_id:ruta.id, numero_serie:row["No de Serie"],numero_motor:row["No de Motor"],transmision:row["Tipo de Transmisión "],numero_factura:row["No Fact Veh"],fecha_compra:row["Fecha de compra"],valor_compra:row["Valor de compra"],numero_factura_adapt:row["No Fact Adapt"],numero_serie_adapt:row["No Serie Adapt"],valor_adapt:row["Valor Adaptacion"],numero_poliza:row["No de Poliza"],inciso:row["Inciso"],numero_placa:row["No Placa"],permiso_federal_carga:row["No Permiso Federal de carga"],permiso_fisico_mecanico:row["No Permiso Fisico Mecanico"],permiso_ambiental:row["No Permiso Ambiental"],litros_autorizados:row["Litros autorizados"],catalog_personal_id:usuario.id,proxima_verificacion:row["Fecha verificación"], permiso_sat: row["Permiso SCT"], numero_permiso: row["Número de permiso"], numero_aseguradora: row["Nombre de aseguradora"], celular: row["Celular"])
              else
                store_vehicles = Vehicle.create(numero_economico:row["Numero economico"],catalog_company_id:compania.id,catalog_branch_id:cedis.id,cost_center_id:centro.id,responsable_id:responsable.id,vehicle_status_id:status.id, vehicle_type_id:tipo.id, catalog_brand_id:linea.id, catalog_model_id:modelo.id,billed_company_id:empresaf.id,policy_coverage_id:cobertura.id,insurance_beneficiary_id:beneficiario.id,plate_state_id:estado.id,catalog_area_id:area.id,catalog_route_id:ruta.id, numero_serie:row["No de Serie"],numero_motor:row["No de Motor"],transmision:row["Tipo de Transmisión "],numero_factura:row["No Fact Veh"],fecha_compra:row["Fecha de compra"],valor_compra:row["Valor de compra"],numero_factura_adapt:row["No Fact Adapt"],numero_serie_adapt:row["No Serie Adapt"],valor_adapt:row["Valor Adaptacion"],numero_poliza:row["No de Poliza"],inciso:row["Inciso"],numero_placa:row["No Placa"],permiso_federal_carga:row["No Permiso Federal de carga"],permiso_fisico_mecanico:row["No Permiso Fisico Mecanico"],permiso_ambiental:row["No Permiso Ambiental"],litros_autorizados:row["Litros autorizados"],catalog_personal_id:usuario.id,proxima_verificacion:row["Fecha verificación"], permiso_sat: row["Permiso SCT"], numero_permiso: row["Número de permiso"], numero_aseguradora: row["Nombre de aseguradora"], celular: row["Celular"])
              end
              #byebug
                if !store_vehicles     
                  store_vehicles.errors.full_messages do |error|
                      hash_vehiculo["Problema"] = error
                      hash_vehiculo["fila"] = i
                      hash_vehiculo["Descripción del artículo"] = row["Descripción del artículo"]
                    end
                    arreglo_vehiculos.push(hash_vehiculo)
                end
            rescue Exception => error
              hash_vehiculo["Problema"] = error
              hash_vehiculo["fila"] = i
                # row["Descripción del artículo"] != "" ? hash_vehiculo["Descripción del artículo"] = row["Descripción del artículo"] :  hash_vehiculo["Descripción del artículo"] = ""
                arreglo_vehiculos.push(hash_vehiculo)
            end
          else
            hash_vehiculo["Problema"] = "Algunos de los campos marcados como obligatorios en el archivo estan vacios, verifique por favor..."
            hash_vehiculo["fila"] = i
              arreglo_vehiculos.push(hash_vehiculo)
          end
      end
    end
    #placas
    if spreadsheet.sheet('Importar placas').count > 1
      (2..spreadsheet.sheet('Importar placas').last_row).each do |i|
        row = Hash[[header_placas, spreadsheet.sheet('Importar placas').row(i)].transpose]
        hash_vehiculo = Hash.new
        no = row["Numero economico"].to_s
        esp = row["Estado plaqueo"].to_s.strip
        

        if row["Numero economico"] == "" or row["Numero economico"].nil?
          hash_vehiculo["Problema"] = "El campo número economico se encuentra vacío."
          hash_vehiculo["fila"] = i
          hash_vehiculo["nombre"] = row["Numero economico"]
          arreglo_vehiculos.push(hash_vehiculo)
          next
        else
          b_vehiculo = Vehicle.find_by(numero_economico: no)
        end

        if !b_vehiculo
          hash_vehiculo["Problema"] = "El vehículo #{row["Numero economico"]} no se encuentra registrado en el maestro de vehículos, verifique por favor."
          hash_vehiculo["fila"] = i
          arreglo_vehiculos.push(hash_vehiculo)
          next
        end
        
        if row["No Placa"] == "" or row["No Placa"].nil?
          hash_vehiculo["Problema"] = "El campo número de placa se encuentra vacío."
          hash_vehiculo["fila"] = i
          hash_vehiculo["nombre"] =  row["No Placa"]
          arreglo_vehiculos.push(hash_vehiculo)
          next
        end

        if row["Estado plaqueo"] == "" or  row["Estado plaqueo"].nil?
          hash_vehiculo["Problema"] = "El campo estado de plaqueo se encuentra vacío."
          hash_vehiculo["fila"] = i
          hash_vehiculo["nombre"] =  row["Estado plaqueo"]
          arreglo_vehiculos.push(hash_vehiculo)
          next
        else
          estado = PlateState.find_by(descripcion: esp)
        end

        if !estado
          hash_vehiculo["Problema"] = "El estado de plaqueo #{row["Estado plaqueo"]} no se encuentra registrado en el catálogo de estado de plaqueo, verifique por favor."
          hash_vehiculo["fila"] = i
          arreglo_vehiculos.push(hash_vehiculo)
            next
        end

        if row["Fecha vigencia"] == "" or  row["Fecha vigencia"].nil?
          hash_vehiculo["Problema"] = "El campo fecha de vigencia se encuentra vacío."
          hash_vehiculo["fila"] = i
          hash_vehiculo["nombre"] =  row["Fecha vigencia"]
          arreglo_vehiculos.push(hash_vehiculo)
          next
        end
          
          begin
            store_vehicles = b_vehiculo.update(numero_placa: row["No Placa"],plate_state_id:estado.id,fecha_vigencia_placas:row["Fecha vigencia"].strftime("%Y-%m-%d"))
            if !store_vehicles     
              store_vehicles.errors.full_messages do |error|
                hash_vehiculo["Problema"] = error
                hash_vehiculo["fila"] = i
                hash_vehiculo["Descripción del artículo"] = row["Descripción del artículo"]
              end
              arreglo_vehiculos.push(hash_vehiculo)
            end
          rescue => error
            hash_vehiculo["Problema"] = error
            hash_vehiculo["fila"] = i
            arreglo_vehiculos.push(hash_vehiculo)
            next
          end
      end 
    end
    #polizas
    if spreadsheet.sheet('Importar pólizas').count > 1
      (2..spreadsheet.sheet('Importar pólizas').last_row).each do |i|
        row = Hash[[header_polizas, spreadsheet.sheet('Importar pólizas').row(i)].transpose]
        hash_vehiculo = Hash.new
        no = row["Numero economico"].to_s
       

        if row["Numero economico"] == "" or row["Numero economico"].nil?
          hash_vehiculo["Problema"] = "El campo número economico se encuentra vacío."
          hash_vehiculo["fila"] = i
          hash_vehiculo["nombre"] = row["Numero economico"]
          arreglo_vehiculos.push(hash_vehiculo)
          next
        else
          b_vehiculo = Vehicle.find_by(numero_economico: no)
        end

        if !b_vehiculo
          hash_vehiculo["Problema"] = "El vehículo #{row["Numero economico"]} no se encuentra registrado en el maestro de vehículos, verifique por favor."
          hash_vehiculo["fila"] = i
          arreglo_vehiculos.push(hash_vehiculo)
          next
        end
        
        if row["No de Poliza"] == "" or  row["No de Poliza"].nil?
          hash_vehiculo["Problema"] = "El campo número de póliza se encuentra vacío."
          hash_vehiculo["fila"] = i
          hash_vehiculo["nombre"] = row["No de Poliza"]
          arreglo_vehiculos.push(hash_vehiculo)
          next
        end

        if row["Inciso"] == "" or  row["Inciso"].nil?
          hash_vehiculo["Problema"] = "El campo inciso se encuentra vacío."
          hash_vehiculo["fila"] = i
          hash_vehiculo["nombre"] =  row["inciso"]
          arreglo_vehiculos.push(hash_vehiculo)
          next
        end

        if row["Fecha vigencia"] == "" or  row["Fecha vigencia"].nil?
          hash_vehiculo["Problema"] = "El campo fecha de vigencia se encuentra vacío."
          hash_vehiculo["fila"] = i
          hash_vehiculo["nombre"] =  row["Fecha vigencia"]
          arreglo_vehiculos.push(hash_vehiculo)
          next
        end

          begin
            store_vehicles = b_vehiculo.update(numero_poliza: row["No de Poliza"],inciso:row["Inciso"],fecha_vigencia_poliza:row["Fecha vigencia"].strftime("%Y-%m-%d"))
            if !store_vehicles     
              store_vehicles.errors.full_messages do |error|
                hash_vehiculo["Problema"] = error
                hash_vehiculo["fila"] = i
                hash_vehiculo["Descripción del artículo"] = row["Descripción del artículo"]
              end
              arreglo_vehiculos.push(hash_vehiculo)
            end
          rescue => error
            hash_vehiculo["Problema"] = error
            hash_vehiculo["fila"] = i
            arreglo_vehiculos.push(hash_vehiculo)
            next
          end
      end 
    end
    #permisos fisicos 
    if spreadsheet.sheet('Importar permisos fisicos').count > 1
      (2..spreadsheet.sheet('Importar permisos fisicos').last_row).each do |i|
        row = Hash[[header_fisicos, spreadsheet.sheet('Importar permisos fisicos').row(i)].transpose]
        hash_vehiculo = Hash.new
        no = row["Numero economico"].to_s
       

        if row["Numero economico"] == "" or row["Numero economico"].nil?
          hash_vehiculo["Problema"] = "El campo número economico se encuentra vacío."
          hash_vehiculo["fila"] = i
          hash_vehiculo["nombre"] = row["Numero economico"]
          arreglo_vehiculos.push(hash_vehiculo)
          next
        else
          b_vehiculo = Vehicle.find_by(numero_economico: no)
        end

        if !b_vehiculo
          hash_vehiculo["Problema"] = "El vehículo #{row["Numero economico"]} no se encuentra registrado en el maestro de vehículos, verifique por favor."
          hash_vehiculo["fila"] = i
          arreglo_vehiculos.push(hash_vehiculo)
          next
        end
        
        if row["No Permiso Fisico Mecanico"] == "" or  row["No Permiso Fisico Mecanico"].nil?
          hash_vehiculo["Problema"] = "El campo número de permiso fisíco mecanico se encuentra vacío."
          hash_vehiculo["fila"] = i
          hash_vehiculo["nombre"] = row["No Permiso Fisico Mecanico"]
          arreglo_vehiculos.push(hash_vehiculo)
          next
        end

        if row["Fecha vigencia"] == "" or  row["Fecha vigencia"].nil?
          hash_vehiculo["Problema"] = "El campo fecha de vigencia se encuentra vacío."
          hash_vehiculo["fila"] = i
          hash_vehiculo["nombre"] =  row["Fecha vigencia"]
          arreglo_vehiculos.push(hash_vehiculo)
          next
        end

          begin
            store_vehicles = b_vehiculo.update(permiso_fisico_mecanico: row["No Permiso Fisico Mecanico"],fecha_vigencia_fisico:row["Fecha vigencia"].strftime("%Y-%m-%d"))
            if !store_vehicles     
              store_vehicles.errors.full_messages do |error|
                hash_vehiculo["Problema"] = error
                hash_vehiculo["fila"] = i
                hash_vehiculo["Descripción del artículo"] = row["Descripción del artículo"]
              end
              arreglo_vehiculos.push(hash_vehiculo)
            end
          rescue => error
            hash_vehiculo["Problema"] = error
            hash_vehiculo["fila"] = i
            arreglo_vehiculos.push(hash_vehiculo)
            next
          end
      end 
    end

     #permisos ambiental
     if spreadsheet.sheet('Importar permisos ambiental').count > 1
      (2..spreadsheet.sheet('Importar permisos ambiental').last_row).each do |i|
        row = Hash[[header_ambiental, spreadsheet.sheet('Importar permisos ambiental').row(i)].transpose]
        hash_vehiculo = Hash.new
        no = row["Numero economico"].to_s
       

        if row["Numero economico"] == "" or row["Numero economico"].nil?
          hash_vehiculo["Problema"] = "El campo número economico se encuentra vacío."
          hash_vehiculo["fila"] = i
          hash_vehiculo["nombre"] = row["Numero economico"]
          arreglo_vehiculos.push(hash_vehiculo)
          next
        else
          b_vehiculo = Vehicle.find_by(numero_economico: no)
        end

        if !b_vehiculo
          hash_vehiculo["Problema"] = "El vehículo #{row["Numero economico"]} no se encuentra registrado en el maestro de vehículos, verifique por favor."
          hash_vehiculo["fila"] = i
          arreglo_vehiculos.push(hash_vehiculo)
          next
        end
        
        if row["No Permiso Ambiental"] == "" or  row["No Permiso Ambiental"].nil?
          hash_vehiculo["Problema"] = "El campo número de permiso ambiental se encuentra vacío."
          hash_vehiculo["fila"] = i
          hash_vehiculo["nombre"] = row["No Permiso Ambiental"]
          arreglo_vehiculos.push(hash_vehiculo)
          next
        end

        if row["Fecha vigencia"] == "" or  row["Fecha vigencia"].nil?
          hash_vehiculo["Problema"] = "El campo fecha de vigencia se encuentra vacío."
          hash_vehiculo["fila"] = i
          hash_vehiculo["nombre"] =  row["Fecha vigencia"]
          arreglo_vehiculos.push(hash_vehiculo)
          next
        end

          begin
            store_vehicles = b_vehiculo.update(permiso_ambiental: row["No Permiso Ambiental"] ,fecha_vigencia_ambiental:row["Fecha vigencia"].strftime("%Y-%m-%d"))
            if !store_vehicles     
              store_vehicles.errors.full_messages do |error|
                hash_vehiculo["Problema"] = error
                hash_vehiculo["fila"] = i
                hash_vehiculo["Descripción del artículo"] = row["Descripción del artículo"]
              end
              arreglo_vehiculos.push(hash_vehiculo)
            end
          rescue => error
            hash_vehiculo["Problema"] = error
            hash_vehiculo["fila"] = i
            arreglo_vehiculos.push(hash_vehiculo)
            next
          end
      end 
    end
    return arreglo_vehiculos
  end

  def self.importar_actualizacion_maestro_vehiculos(file)
    spreadsheet = Roo::Spreadsheet.open(file.path)
    arreglo_vehiculos = Array.new()
    header = spreadsheet.sheet('Importación').row(8)
    (9..spreadsheet.last_row).each do |i|
      row = Hash[[header, spreadsheet.row(i)].transpose]
      # if i == 9
      #   byebug
      # end
      if (row["Identificador"] != "" and !row["Identificador"].nil?) && (row["Número económico"] != "" and !row["Número económico"].nil?) && (row["Empresa *"] != "" and !row["Empresa *"].nil?) && (row["Centro de costo *"] != "" and !row["Centro de costo *"].nil?) && (row["Responsable *"] != "" and !row["Responsable *"].nil?) && (row["Usuario *"] != "" and !row["Usuario *"].nil?) && (row["Estatus del vehículo *"] != "" and !row["Estatus del vehículo *"].nil?) && (row["Tipo de vehículo *"] != "" and !row["Tipo de vehículo *"].nil?) && (row["Ruta *"] != "" and !row["Ruta *"].nil?) && (row["Cobertura de póliza *"] != "" and !row["Cobertura de póliza *"].nil?) && (row["Beneficiario *"] != "" and !row["Beneficiario *"].nil?) && (row["Estado de plaqueo *"] != "" and !row["Estado de plaqueo *"].nil?) && (row["Modelo *"] != "" and !row["Modelo *"].nil?) && (row["Año *"] != "" and !row["Año *"].nil?) && (row["Cedis *"] != "" and !row["Cedis *"].nil?) && (row["Área *"] != "" and !row["Área *"].nil?)
        vehiculo = Vehicle.find_by(id: row["Identificador"])
        if !vehiculo
          arreglo_vehiculos.push(problema: "No existe el vehículo seleccionado.",fila:i)
          next
        end
        # empresa = CatalogBranch.find_by(id: row["Empresa *"])
        # if !empresa
        #   arreglo_vehiculos.push(problema: "No existe la empresa seleccionada.",fila:i)
        #   next
        # end
        centro_costo = CostCenter.find_by(id: row["Centro de costo *"])
        if !centro_costo
          arreglo_vehiculos.push(problema: "No existe el centro de costo seleccionado.",fila:i)
          next
        end
        responsable = Responsable.find_by(id: row["Responsable *"])
        if !responsable
          arreglo_vehiculos.push(problema: "No existe el responsable seleccionado.",fila:i)
          next
        end
        usuario = CatalogPersonal.find_by(id: row["Usuario *"])
        if !usuario
          arreglo_vehiculos.push(problema: "No existe el usuario seleccionado.",fila:i)
          next
        end
        estatus_vehiculo = VehicleStatus.find_by(id: row["Estatus del vehículo *"])
        if !estatus_vehiculo
          arreglo_vehiculos.push(problema: "No existe el estatus del vehículo seleccionado.",fila:i)
          next
        end
        tipo_vehiculo = VehicleType.find_by(id: row["Tipo de vehículo *"])
        if !tipo_vehiculo
          arreglo_vehiculos.push(problema: "No existe el tipo de vehículo seleccionado.",fila:i)
          next
        end
        empresa_facturable = BilledCompany.find_by(id: row["Empresa facturable *"])
        if !empresa_facturable
          arreglo_vehiculos.push(problema: "No existe la empresa facturable seleccionada.",fila:i)
          next
        end
        ruta = CatalogRoute.find_by(id: row["Ruta *"])
        if !ruta
          arreglo_vehiculos.push(problema: "No existe la ruta seleccionada.",fila:i)
          next
        end
        cobertura_poliza = PolicyCoverage.find_by(id: row["Cobertura de póliza *"])
        if !cobertura_poliza
          arreglo_vehiculos.push(problema: "No existe la cobertura de póliza seleccionada.",fila:i)
          next
        end
        beneficiario = InsuranceBeneficiary.find_by(id: row["Beneficiario *"])
        if !beneficiario
          arreglo_vehiculos.push(problema: "No existe el beneficiario seleccionado.",fila:i)
          next
        end
        estado_plaqueo = PlateState.find_by(id: row["Estado de plaqueo *"])
        if !estado_plaqueo
          arreglo_vehiculos.push(problema: "No existe el estado de plaqueo seleccionado.",fila:i)
          next
        end
        modelo = CatalogBrand.find_by(id: row["Modelo *"])
        if !modelo
          arreglo_vehiculos.push(problema: "No existe el modelo seleccionado.",fila:i)
          next
        end
        anio = CatalogModel.find_by(id: row["Año *"])
        if !anio
          arreglo_vehiculos.push(problema: "No existe el año seleccionado.",fila:i)
          next
        end
        cedis = CatalogBranch.find_by(id: row["Cedis *"])
        if !cedis
          arreglo_vehiculos.push(problema: "No existe el cedis seleccionado.",fila:i)
          next
        end
        area = CatalogArea.find_by(id: row["Área *"])
        if !area
          arreglo_vehiculos.push(problema: "No existe el área seleccionada.",fila:i)
          next
        end
        # almacen = Warehouse.find_by(id: row["Álmacen *"])
        # if !almacen
        #   next
        # end
        if row["Tipo de permiso * (opcional)"].nil? or row["Tipo de permiso * (opcional)"] == ""
          tipo_permiso = nil
        else
          permiso = PermissionType.find_by(id: row["Tipo de permiso * (opcional)"])
          if !permiso
            tipo_permiso = nil
            # arreglo_vehiculos.push(problema: "No existe el tipo de permiso seleccionado.",fila:i)
            # next
          else
            tipo_permiso = permiso.id
          end
        end
        if row["Configuración del vehículo * (opcional)"].nil? or row["Configuración del vehículo * (opcional)"] == ""
          config = nil
        else
          configuracion = VehicleConfiguration.find_by(id: row["Configuración del vehículo * (opcional)"])
          if !configuracion
            config = nil
            # arreglo_vehiculos.push(problema: "No existe la configuración del vehículo seleccionada.",fila:i)
            # next
          else
            config = configuracion.id
          end
        end
        if row["Subtipo de remolque * (opcional)"].nil? or row["Subtipo de remolque * (opcional)"] == ""
          sub_rem = nil
        else
          subtipo_remolque = TrailerSubtype.find_by(id: row["Subtipo de remolque * (opcional)"])
          if subtipo_remolque
            sub_rem = subtipo_remolque.id
          else
            sub_rem = nil
            # arreglo_vehiculos.push(problema: "No existe el subtipo de remolque seleccionado.",fila:i)
            # next
          end
        end

        row["Fecha de compra"] != "" and !row["Fecha de compra"].nil? ? fecha_compra = row["Fecha de compra"].to_date : fecha_compra = nil
        row["Fecha de licencia"] != "" and !row["Fecha de licencia"].nil? ? fecha_licencia = row["Fecha de licencia"] : fecha_licencia = nil
        row["Fecha de vigencia de placas"] != "" and !row["Fecha de vigencia de placas"].nil? ? fecha_vigencia_placas = row["Fecha de vigencia de placas"] : fecha_vigencia_placas = nil
        row["Fecha de vigencia de póliza"] != "" and !row["Fecha de vigencia de póliza"].nil? ? fecha_vigencia_poliza = row["Fecha de vigencia de póliza"] : fecha_vigencia_poliza = nil
        row["Fecha de vigencia fisicomecánica"] != "" and !row["Fecha de vigencia fisicomecánica"].nil? ? fecha_vigencia_fisico = row["Fecha de vigencia fisicomecánica"] : fecha_vigencia_fisico = nil
        row["Fecha de vigencia ambiental"] != "" and !row["Fecha de vigencia ambiental"].nil? ? fecha_vigencia_ambiental = row["Fecha de vigencia ambiental"] : fecha_vigencia_ambiental = nil

        # Se pidió poner vacío el subtipo de remolque
        #sub_rem = nil
        Vehicle.transaction do
          if vehiculo.update(
              numero_economico: row["Número económico"], 
              cost_center_id: row["Centro de costo *"], 
              responsable_id: row["Responsable *"], 
              catalog_personal_id: row["Usuario *"],  
              celular_responsable: row["Celular responsable"], 
              vehicle_status_id: row["Estatus del vehículo *"], 
              vehicle_type_id: row["Tipo de vehículo *"], 
              numero_serie: row["Número de serie"], 
              numero_motor: row["Número de motor"], 
              transmision: row["Transimisión (Std/Aut)"], 
              billed_company_id: row["Empresa facturable *"], 
              numero_factura: row["Número de factura"], 
              fecha_compra: fecha_compra, 
              valor_compra: row["Valor de compra"], 
              numero_factura_adapt: row["Número de factura de adaptación"], 
              numero_serie_adapt: row["Número de serie de adaptación"], 
              valor_adapt: row["Valor de adaptación"], 
              catalog_route_id: row["Ruta *"], 
              numero_poliza: row["Número de póliza"], 
              inciso: row["Inciso"], 
              policy_coverage_id: row["Cobertura de póliza *"], 
              insurance_beneficiary_id: row["Beneficiario *"], 
              numero_placa: row["Número de placa"], 
              plate_state_id: row["Estado de plaqueo *"], 
              permiso_federal_carga: row["Permiso federal de carga"], 
              permiso_fisico_mecanico: row["Permiso fisicomecánico"], 
              permiso_ambiental: row["Permiso ambiental"], 
              litros_autorizados: row["Litros autorizados"], 
              catalog_brand_id: row["Modelo *"], 
              catalog_model_id: row["Año *"], 
              catalog_branch_id: row["Cedis *"], 
              catalog_area_id: row["Área *"], 
              warehouse_id: row["Almacén *"], 
              vehicle_color: row["Color"], 
              impuestos: row["Impuestos"], 
              fecha_licencia: fecha_licencia, 
              numero_licencia: row["Número de licencia"], 
              fecha_vigencia_placas: fecha_vigencia_placas, 
              fecha_vigencia_poliza: fecha_vigencia_poliza, 
              fecha_vigencia_fisico: fecha_vigencia_fisico, 
              fecha_vigencia_ambiental: fecha_vigencia_ambiental, 
              permiso_sat: row["Permiso SCT"], 
              numero_permiso: row["Número de permiso"], 
              numero_aseguradora: row["Nombre de aseguradora"], 
              permission_type_id: tipo_permiso, 
              vehicle_configuration_id: config, 
              trailer_subtype_id: sub_rem
            )
            #if vehiculo.vehicle_status_id == 1
              envio_jde = actualizar_vehiculo_jde(vehiculo.id)
              if envio_jde[0] == false
                mensaje = "Error en la solicitud a JD Edwards: "
                envio_jde[1].map{|x| x["Mensaje"]}.each do |error|
                  mensaje += "#{error}. "
                end
                arreglo_vehiculos.push(problema: mensaje,fila:i)
                raise ActiveRecord::Rollback
                next
              end
            #end
          else
            mensaje = ""
            vehiculo.errors.full_messages.each do |error|
              mensaje += "#{error}. "
            end
            arreglo_vehiculos.push(problema: mensaje,fila:i)
            next
          end
        end
      else
        arreglo_vehiculos.push(problema: "Complete correctamente los campos obligatorios marcados con *",fila:i)
        next
      end
    end
    return arreglo_vehiculos
  end
  

  def self.consulta_x_numeconomico(numero_economico)
    Vehicle.find_by(numero_economico: numero_economico)
  end

  def self.consulta_x_serie(numero_serie)
    Vehicle.find_by(numero_serie: numero_serie)
  end

  def log_crear
    VehicleLog.create(texto: "El usuario #{User.current_user.name} #{User.current_user.last_name} registró el vehículo con número económico #{self.numero_economico}.", vehicle_id: self.id, user_id: User.current_user.id)
  end

  def log_actualizar
    #byebug

    if self.numero_economico_changed?
      VehicleLog.create(texto: "El usuario #{User.current_user.name} #{User.current_user.last_name} modificó el número económico de  '#{self.numero_economico_change[0]}' a '#{self.numero_economico_change[1]}'.", vehicle_id: self.id, user_id: User.current_user.id)
    end

    if self.catalog_company_id_changed?
      company_nva = CatalogCompany.find_by(id: self.catalog_company_id_change[1])
      if self.catalog_company_id_change[0].nil? or self.catalog_company_id_change[0] == ""
        VehicleLog.create(texto: "El usuario #{User.current_user.name} #{User.current_user.last_name} agregó la empresa '#{company_nva.nombre}'.", vehicle_id: self.id, user_id: User.current_user.id)
      else
        company_ant = CatalogCompany.find_by(id: self.catalog_company_id_change[0])
        VehicleLog.create(texto: "El usuario #{User.current_user.name} #{User.current_user.last_name} modificó la empresa de '#{company_ant.nombre}' a '#{company_nva.nombre}'.", vehicle_id: self.id, user_id: User.current_user.id)
      end
    end

    if self.cost_center_id_changed?
      center_nva = CostCenter.find_by(id: self.cost_center_id_change[1])
      if self.cost_center_id_change[0].nil? or self.cost_center_id_change[0] == ""
        VehicleLog.create(texto: "El usuario #{User.current_user.name} #{User.current_user.last_name} agregó el centro de costos '#{center_nva.descripcion}'.", vehicle_id: self.id, user_id: User.current_user.id)
      else
        center_ant = CostCenter.find_by(id: self.cost_center_id_change[0])
        VehicleLog.create(texto: "El usuario #{User.current_user.name} #{User.current_user.last_name} modificó el centro de costos de '#{center_ant.descripcion}' a '#{center_nva.descripcion}'.", vehicle_id: self.id, user_id: User.current_user.id)
      end
    end

    if self.responsable_id_changed?
      responsable_nva = Responsable.find_by(id: self.responsable_id_change[1])
      if self.responsable_id_change[0].nil? or self.responsable_id_change[0] == ""
        VehicleLog.create(texto: "El usuario #{User.current_user.name} #{User.current_user.last_name} agregó el responsable '#{responsable_nva.nombre}'.", vehicle_id: self.id, user_id: User.current_user.id)
      else
        responsable_ant = Responsable.find_by(id: self.responsable_id_change[0])
        if responsable_ant.nombre != ""
          VehicleLog.create(texto: "El usuario #{User.current_user.name} #{User.current_user.last_name} modificó el responsable de '#{responsable_ant.nombre}' a '#{responsable_nva.nombre}'.", vehicle_id: self.id, user_id: User.current_user.id)
        end
      end
    end

    if self.vehicle_status_id_changed?
      vehicle_status_nva = VehicleStatus.find_by(id: self.vehicle_status_id_change[1])
      if self.vehicle_status_id_change[0].nil? or self.vehicle_status_id_change[0] == ""
        VehicleLog.create(texto: "El usuario #{User.current_user.name} #{User.current_user.last_name} agregó el estatus '#{vehicle_status_nva.descripcion}'.", vehicle_id: self.id, user_id: User.current_user.id)
      else
        vehicle_status_ant = VehicleStatus.find_by(id: self.vehicle_status_id_change[0])
        VehicleLog.create(texto: "El usuario #{User.current_user.name} #{User.current_user.last_name} modificó el estatus de '#{vehicle_status_ant.descripcion}' a '#{vehicle_status_nva.descripcion}'.", vehicle_id: self.id, user_id: User.current_user.id)
      end
    end

    if self.vehicle_type_id_changed?
      vehicle_type_nva = VehicleType.find_by(id: self.vehicle_type_id_change[1])
      if self.vehicle_type_id_change[0].nil? or self.vehicle_type_id_change[0] == ""
        VehicleLog.create(texto: "El usuario #{User.current_user.name} #{User.current_user.last_name} agregó el tipo de vehículo '#{vehicle_type_nva.descripcion}'.", vehicle_id: self.id, user_id: User.current_user.id)
      else
        vehicle_type_ant = VehicleType.find_by(id: self.vehicle_type_id_change[0])
        VehicleLog.create(texto: "El usuario #{User.current_user.name} #{User.current_user.last_name} modificó el tipo de vehículo de '#{vehicle_type_ant.descripcion}' a '#{vehicle_type_nva.descripcion}'.", vehicle_id: self.id, user_id: User.current_user.id)
      end
    end

    if self.numero_serie_changed?
      VehicleLog.create(texto: "El usuario #{User.current_user.name} #{User.current_user.last_name} modificó el número de serie de  '#{self.numero_serie_change[0]}' a '#{self.numero_serie_change[1]}'.", vehicle_id: self.id, user_id: User.current_user.id)
    end

    if self.numero_motor_changed?
      VehicleLog.create(texto: "El usuario #{User.current_user.name} #{User.current_user.last_name} modificó el número de motor de  '#{self.numero_motor_change[0]}' a '#{self.numero_motor_change[1]}'.", vehicle_id: self.id, user_id: User.current_user.id)
    end

    if self.transmision_changed?
      VehicleLog.create(texto: "El usuario #{User.current_user.name} #{User.current_user.last_name} modificó la transmisión de  '#{self.transmision_change[0]}' a '#{self.transmision_change[1]}'.", vehicle_id: self.id, user_id: User.current_user.id)
    end

    if self.billed_company_id_changed?
      billed_company_nva = BilledCompany.find_by(id: self.billed_company_id_change[1])
      if self.billed_company_id_change[0].nil? or self.billed_company_id_change[0] == ""
        VehicleLog.create(texto: "El usuario #{User.current_user.name} #{User.current_user.last_name} agregó la empresa de factura '#{billed_company_nva.nombre}'.", vehicle_id: self.id, user_id: User.current_user.id)
      elsif self.billed_company_id_change[1].nil? or self.billed_company_id_change[1] == ""
        billed_company_ant = BilledCompany.find_by(id: self.billed_company_id_change[0])
        VehicleLog.create(texto: "El usuario #{User.current_user.name} #{User.current_user.last_name} removió la empresa de factura '#{billed_company_ant.nombre}'.", vehicle_id: self.id, user_id: User.current_user.id)
      else
        billed_company_ant = BilledCompany.find_by(id: self.billed_company_id_change[0])
        VehicleLog.create(texto: "El usuario #{User.current_user.name} #{User.current_user.last_name} modificó la empresa de factura de '#{billed_company_ant.nombre}' a '#{billed_company_nva.nombre}'.", vehicle_id: self.id, user_id: User.current_user.id)
      end
    end

    if self.numero_factura_changed?
      VehicleLog.create(texto: "El usuario #{User.current_user.name} #{User.current_user.last_name} modificó el número de factura de  '#{self.numero_factura_change[0]}' a '#{self.numero_factura_change[1]}'.", vehicle_id: self.id, user_id: User.current_user.id)
    end

    if self.fecha_compra_changed?
      VehicleLog.create(texto: "El usuario #{User.current_user.name} #{User.current_user.last_name} modificó la fecha de compra de  '#{self.fecha_compra_change[0]}' a '#{self.fecha_compra_change[1]}'.", vehicle_id: self.id, user_id: User.current_user.id)
    end

    if self.valor_compra_changed?
      if self.valor_compra_change[0].nil? or self.valor_compra_change[0] == ""
        VehicleLog.create(texto: "El usuario #{User.current_user.name} #{User.current_user.last_name} agregó el valor de compra '#{number_to_currency(self.valor_compra_change[1])}'.", vehicle_id: self.id, user_id: User.current_user.id)
      else
        VehicleLog.create(texto: "El usuario #{User.current_user.name} #{User.current_user.last_name} modificó el valor de compra de '#{number_to_currency(self.valor_compra_change[0])}' a '#{number_to_currency(self.valor_compra_change[1])}'.", vehicle_id: self.id, user_id: User.current_user.id)
      end
    end

    if self.numero_factura_adapt_changed?
      VehicleLog.create(texto: "El usuario #{User.current_user.name} #{User.current_user.last_name} modificó el número de factura de adaptación de  '#{self.numero_factura_adapt_change[0]}' a '#{self.numero_factura_adapt_change[1]}'.", vehicle_id: self.id, user_id: User.current_user.id)
    end

    if self.numero_serie_adapt_changed?
      VehicleLog.create(texto: "El usuario #{User.current_user.name} #{User.current_user.last_name} modificó el número de serie de adaptación de  '#{self.numero_serie_adapt_change[0]}' a '#{self.numero_serie_adapt_change[1]}'.", vehicle_id: self.id, user_id: User.current_user.id)
    end

    if self.valor_adapt_changed?
      VehicleLog.create(texto: "El usuario #{User.current_user.name} #{User.current_user.last_name} modificó el valor de adaptación de  '#{self.valor_adapt_change[0]}' a '#{self.valor_adapt_change[1]}'.", vehicle_id: self.id, user_id: User.current_user.id)
    end

    if self.catalog_route_id_changed?
      catalog_route_nva = CatalogRoute.find_by(id: self.catalog_route_id_change[1])
      if self.catalog_route_id_change[0].nil? or self.catalog_route_id_change[0] == ""
        VehicleLog.create(texto: "El usuario #{User.current_user.name} #{User.current_user.last_name} agregó la ruta '#{catalog_route_nva.descripcion}'.", vehicle_id: self.id, user_id: User.current_user.id)
      else
        catalog_route_ant = CatalogRoute.find_by(id: self.catalog_route_id_change[0])
        VehicleLog.create(texto: "El usuario #{User.current_user.name} #{User.current_user.last_name} modificó la ruta de '#{catalog_route_ant.descripcion}' a '#{catalog_route_nva.descripcion}'.", vehicle_id: self.id, user_id: User.current_user.id)
      end
    end

    if self.numero_poliza_changed?
      VehicleLog.create(texto: "El usuario #{User.current_user.name} #{User.current_user.last_name} modificó el número de póliza de  '#{self.numero_poliza_change[0]}' a '#{self.numero_poliza_change[1]}'.", vehicle_id: self.id, user_id: User.current_user.id)
    end

    if self.inciso_changed?
      VehicleLog.create(texto: "El usuario #{User.current_user.name} #{User.current_user.last_name} modificó el número de póliza de  '#{self.inciso_change[0]}' a '#{self.inciso_change[1]}'.", vehicle_id: self.id, user_id: User.current_user.id)
    end

    if self.policy_coverage_id_changed?
      policy_coverage_nva = PolicyCoverage.find_by(id: self.policy_coverage_id_change[1])
      if self.policy_coverage_id_change[0].nil? or self.policy_coverage_id_change[0] == ""
        VehicleLog.create(texto: "El usuario #{User.current_user.name} #{User.current_user.last_name} agregó la póliza '#{policy_coverage_nva.descripcion}'.", vehicle_id: self.id, user_id: User.current_user.id)
      else
        policy_coverage_ant = PolicyCoverage.find_by(id: self.policy_coverage_id_change[0])
        VehicleLog.create(texto: "El usuario #{User.current_user.name} #{User.current_user.last_name} modificó la póliza de '#{policy_coverage_ant.descripcion}' a '#{policy_coverage_nva.descripcion}'.", vehicle_id: self.id, user_id: User.current_user.id)
      end
    end

    if self.insurance_beneficiary_id_changed?
      insurance_beneficiary_nva = InsuranceBeneficiary.find_by(id: self.insurance_beneficiary_id_change[1])
      if self.insurance_beneficiary_id_change[0].nil? or self.insurance_beneficiary_id_change[0] == ""
        VehicleLog.create(texto: "El usuario #{User.current_user.name} #{User.current_user.last_name} agregó el beneficiario de seguro '#{insurance_beneficiary_nva.descripcion}'.", vehicle_id: self.id, user_id: User.current_user.id)
      else
        insurance_beneficiary_ant = InsuranceBeneficiary.find_by(id: self.insurance_beneficiary_id_change[0])
        VehicleLog.create(texto: "El usuario #{User.current_user.name} #{User.current_user.last_name} modificó el beneficiario de seguro de '#{insurance_beneficiary_ant.descripcion}' a '#{insurance_beneficiary_nva.descripcion}'.", vehicle_id: self.id, user_id: User.current_user.id)
      end
    end

    if self.plate_state_id_changed?
      #byebug
      plate_nva = PlateState.find_by(id: self.plate_state_id_change[1])
      if self.plate_state_id_change[0].nil? or self.plate_state_id_change[0] == ""
        VehicleLog.create(texto: "El usuario #{User.current_user.name} #{User.current_user.last_name} agregó el estado de plaqueo '#{plate_nva.descripcion}'.", vehicle_id: self.id, user_id: User.current_user.id)
      else
        plate_ant = PlateState.find_by(id: self.plate_state_id_change[0])
        VehicleLog.create(texto: "El usuario #{User.current_user.name} #{User.current_user.last_name} modificó el estado de plaqueo de '#{plate_ant.descripcion}' a '#{plate_nva.descripcion}'.", vehicle_id: self.id, user_id: User.current_user.id)
      end
    end

    if self.permiso_federal_carga_changed?
      VehicleLog.create(texto: "El usuario #{User.current_user.name} #{User.current_user.last_name} modificó el permiso federal de  '#{self.permiso_federal_carga_change[0]}' a '#{self.permiso_federal_carga_change[1]}'.", vehicle_id: self.id, user_id: User.current_user.id)
    end

    if self.permiso_fisico_mecanico_changed?
      VehicleLog.create(texto: "El usuario #{User.current_user.name} #{User.current_user.last_name} modificó el permiso físico mecánico de  '#{self.permiso_fisico_mecanico_change[0]}' a '#{self.permiso_fisico_mecanico_change[1]}'.", vehicle_id: self.id, user_id: User.current_user.id)
    end

    if self.permiso_ambiental_changed?
      VehicleLog.create(texto: "El usuario #{User.current_user.name} #{User.current_user.last_name} modificó el permiso ambiental de  '#{self.permiso_ambiental_change[0]}' a '#{self.permiso_ambiental_change[1]}'.", vehicle_id: self.id, user_id: User.current_user.id)
    end

    if self.litros_autorizados_changed?
      VehicleLog.create(texto: "El usuario #{User.current_user.name} #{User.current_user.last_name} modificó los litros autorizados de  '#{self.litros_autorizados_change[0]}' a '#{self.litros_autorizados_change[1]}'.", vehicle_id: self.id, user_id: User.current_user.id)
    end

    if self.catalog_model_id_changed?
      catalog_model_nva = CatalogModel.find_by(id: self.catalog_model_id_change[1])
      if self.catalog_model_id_change[0].nil? or self.catalog_model_id_change[0] == ""
        VehicleLog.create(texto: "El usuario #{User.current_user.name} #{User.current_user.last_name} agregó el modelo '#{catalog_model_nva.descripcion}'.", vehicle_id: self.id, user_id: User.current_user.id)
      else
        catalog_model_ant = CatalogModel.find_by(id: self.catalog_model_id_change[0])
        VehicleLog.create(texto: "El usuario #{User.current_user.name} #{User.current_user.last_name} modificó el modelo de '#{catalog_model_ant.descripcion}' a '#{catalog_model_nva.descripcion}'.", vehicle_id: self.id, user_id: User.current_user.id)
      end
    end

    if self.catalog_brand_id_changed?
      catalog_brand_nva = CatalogBrand.find_by(id: self.catalog_brand_id_change[1])
      if self.catalog_brand_id_change[0].nil? or self.catalog_brand_id_change[0] == ""
        VehicleLog.create(texto: "El usuario #{User.current_user.name} #{User.current_user.last_name} agregó la marca '#{catalog_brand_nva.descripcion}'.", vehicle_id: self.id, user_id: User.current_user.id)
      else
        catalog_brand_ant = CatalogBrand.find_by(id: self.catalog_brand_id_change[0])
        VehicleLog.create(texto: "El usuario #{User.current_user.name} #{User.current_user.last_name} modificó la marca de '#{catalog_brand_ant.descripcion}' a '#{catalog_brand_nva.descripcion}'.", vehicle_id: self.id, user_id: User.current_user.id)
      end
    end

    if self.catalog_branch_id_changed?
      catalog_branch_nva = CatalogBranch.find_by(id: self.catalog_branch_id_change[1])
      if self.catalog_branch_id_change[0].nil? or self.catalog_branch_id_change[0] == ""
        VehicleLog.create(texto: "El usuario #{User.current_user.name} #{User.current_user.last_name} agregó el CEDIS '#{catalog_branch_nva.decripcion}'.", vehicle_id: self.id, user_id: User.current_user.id)
        VehicleTransferLog.create(vehicle_id: self.id, catalog_branch_id: catalog_branch_nva.id, user_id: User.current_user.id, fecha: Time.zone.now)
      else
        if self.catalog_branch_id_change[0] == nil
          #catalog_branch_ant = CatalogBranch.find_by(id: self.catalog_branch_id_change[0])
          #VehicleLog.create(texto: "El usuario #{User.current_user.name} #{User.current_user.last_name} modificó el CEDIS de '#{catalog_branch_ant.decripcion}' a '#{catalog_branch_nva.decripcion}'.", vehicle_id: self.id, user_id: User.current_user.id)
          #VehicleTransferLog.create(vehicle_id: self.id, catalog_branch_id: catalog_branch_nva.id, cedis_ant_id: catalog_branch_ant.id, user_id: User.current_user.id, fecha: Time.zone.now)
        else
          catalog_branch_ant = CatalogBranch.find_by(id: self.catalog_branch_id_change[0])
          VehicleLog.create(texto: "El usuario #{User.current_user.name} #{User.current_user.last_name} modificó el CEDIS de '#{catalog_branch_ant.decripcion}' a '#{catalog_branch_nva.decripcion}'.", vehicle_id: self.id, user_id: User.current_user.id)
          VehicleTransferLog.create(vehicle_id: self.id, catalog_branch_id: catalog_branch_nva.id, cedis_ant_id: catalog_branch_ant.id, user_id: User.current_user.id, fecha: Time.zone.now)
        end
      end
    end

    if self.catalog_area_id_changed?
      catalog_area_nva = CatalogArea.find_by(id: self.catalog_area_id_change[1])
      if self.catalog_area_id_change[0].nil? or self.catalog_area_id_change[0] == ""
        VehicleLog.create(texto: "El usuario #{User.current_user.name} #{User.current_user.last_name} agregó el área '#{catalog_area_nva.descripcion}'.", vehicle_id: self.id, user_id: User.current_user.id)
      else
        catalog_area_ant = CatalogArea.find_by(id: self.catalog_area_id_change[0])
        VehicleLog.create(texto: "El usuario #{User.current_user.name} #{User.current_user.last_name} modificó el área de '#{catalog_area_ant.descripcion}' a '#{catalog_area_nva.descripcion}'.", vehicle_id: self.id, user_id: User.current_user.id)
      end
    end

    if self.catalog_personal_id_changed?
      catalog_personal_nva = CatalogPersonal.find_by(id: self.catalog_personal_id_change[1])
      if self.catalog_personal_id_change[0].nil? or self.catalog_personal_id_change[0] == ""
        VehicleLog.create(texto: "El usuario #{User.current_user.name} #{User.current_user.last_name} agregó el usuario '#{catalog_personal_nva.nombre}'.", vehicle_id: self.id, user_id: User.current_user.id)
      else
        catalog_personal_ant = CatalogPersonal.find_by(id: self.catalog_personal_id_change[0])
        if catalog_personal_ant.nombre != ""
          VehicleLog.create(texto: "El usuario #{User.current_user.name} #{User.current_user.last_name} modificó el usuario de '#{catalog_personal_ant.nombre}' a '#{catalog_personal_nva.nombre}'.", vehicle_id: self.id, user_id: User.current_user.id)  
        end
      end
    end

    if self.vehicle_color_changed?
      VehicleLog.create(texto: "El usuario #{User.current_user.name} #{User.current_user.last_name} modificó el color del vehículo de  '#{self.vehicle_color_change[0]}' a '#{self.vehicle_color_change[1]}'.", vehicle_id: self.id, user_id: User.current_user.id)
    end

    if self.impuestos_changed?
      if self.impuestos_change[0].nil? or self.impuestos_change[0] == ""
        VehicleLog.create(texto: "El usuario #{User.current_user.name} #{User.current_user.last_name} agregó el impuesto '#{number_to_currency(self.impuestos_change[1])}'.", vehicle_id: self.id, user_id: User.current_user.id)
      else
        VehicleLog.create(texto: "El usuario #{User.current_user.name} #{User.current_user.last_name} modificó el impuesto de '#{number_to_currency(self.impuestos_change[0])}' a '#{number_to_currency(self.impuestos_change[1])}'.", vehicle_id: self.id, user_id: User.current_user.id)
      end
    end

    if self.fecha_licencia_changed?
      VehicleLog.create(texto: "El usuario #{User.current_user.name} #{User.current_user.last_name} modificó la fecha de vigencia de licencia de '#{self.fecha_licencia_change[0]}' a '#{self.fecha_licencia_change[1]}'.", vehicle_id: self.id, user_id: User.current_user.id)
    end

    if self.numero_licencia_changed?
      VehicleLog.create(texto: "El usuario #{User.current_user.name} #{User.current_user.last_name} modificó la numero de licencia de '#{self.numero_licencia_change[0]}' a '#{self.numero_licencia_change[1]}'.", vehicle_id: self.id, user_id: User.current_user.id)
    end

    if self.rendimiento_ideal_changed?
      VehicleLog.create(texto: "El usuario #{User.current_user.name} #{User.current_user.last_name} modificó el rendimiento ideal de '#{self.rendimiento_ideal_change[0]}' a '#{self.rendimiento_ideal_change[1]}'.", vehicle_id: self.id, user_id: User.current_user.id)
    end
    if self.proxima_verificacion_changed?
      VehicleLog.create(texto: "El usuario #{User.current_user.name} #{User.current_user.last_name} modificó la fecha de verificación de  '#{self.proxima_verificacion_change[0]}' a '#{self.proxima_verificacion_change[1]}'.", vehicle_id: self.id, user_id: User.current_user.id)
    end

    if self.reparto_changed?
      self.reparto_change[0] == true ? anterior = "Activo" : anterior = "Inactivo"
      self.reparto_change[1] == true ? nuevo = "Activo" : nuevo = "Inactivo"
      VehicleLog.create(texto: "El usuario #{User.current_user.name} #{User.current_user.last_name} modificó la opción de reparto de  '#{anterior}' a '#{nuevo}'.", vehicle_id: self.id, user_id: User.current_user.id)
    end
  end

  # def self.actualizar_vehiculo_jde(id)
  #   vehicle = Vehicle.find_by(id: id)
  #   paremetro_nombre = Parameter.find_by(nombre:"Url Carta Porte")
  #   if vehicle and paremetro_nombre
  #     arreglo = Array.new
  #     hash_vehiculo = Hash.new
  #     hash_secundario = Hash.new
  #     hash_principal = Hash.new
  #     if vehicle.reparto == true
  #       repartoveh = 1
  #     elsif vehicle.reparto == false
  #       repartoveh = 0
  #     else
  #       repartoveh = "NA"
  #     end
  #     hash_vehiculo["noEconomico"]              = vehicle.numero_economico
  #     hash_vehiculo["Compania"]                 = vehicle.catalog_company ? vehicle.catalog_company.clave : "NA"
  #     hash_vehiculo["TipoUnidad"]                = vehicle.vehicle_type.clave
  #     hash_vehiculo["placaVehicular"]              = vehicle.numero_placa
  #     hash_vehiculo["cedis"]                      = vehicle.catalog_branch.clave_jd
  #     hash_vehiculo["area"]                      = vehicle.catalog_area.abreviacion
  #     hash_vehiculo["responsable"]               = vehicle.catalog_personal ? vehicle.catalog_personal.clave : "NA"
  #     hash_vehiculo["anoModelo"]                = vehicle.catalog_model ? vehicle.catalog_model.descripcion : "NA"
  #     hash_vehiculo["noPoliza"]                  = vehicle.numero_poliza 
  #     hash_vehiculo["cobertura"]                 = vehicle.policy_coverage ? vehicle.policy_coverage.clave : "NA"
  #     hash_vehiculo["permisoSCT"]               = vehicle.permission_type ? vehicle.permission_type.clave : "NA"
  #     hash_vehiculo["configVehicular"]            = vehicle.vehicle_configuration ? vehicle.vehicle_configuration.clave : "NA"
  #     hash_vehiculo["subtipoRemolque"]           = vehicle.trailer_subtype ? vehicle.trailer_subtype.clave : "NA"
  #     hash_vehiculo["numeroPermisoSCT"]        = vehicle.permiso_sat
  #     hash_vehiculo["licencia"]                   = vehicle.numero_licencia
  #     hash_vehiculo["nombreAseguradora"]        = vehicle.numero_aseguradora
  #     hash_vehiculo["unidadRemolque"]           = vehicle.vehicle_type.clave == "010" ? 1 : 0
  #     hash_vehiculo["estatus"]                    = vehicle.vehicle_status.nombre == "Inac" ? 0 : 1
  #     hash_vehiculo["reparto"]                    = repartoveh
  #     arreglo.push(hash_vehiculo)
  #     hash_secundario["Vehiculo"]                 = arreglo
  #     hash_principal["vehiculoInput"]              = hash_secundario
  #     url = URI(paremetro_nombre.valor_extendido)
  #     https = Net::HTTP.new(url.host, url.port);
  #     request = Net::HTTP::Put.new(url)
  #     request["Content-Type"] = "application/json"
  #     request["Accept"] = "application/json"
  #     request.body = hash_principal.to_json
  #     response = https.request(request)
  #     @json_parciado = []
  #     respuesta = JSON.parse response.body
  #     if respuesta[0].nil?
  #       @json_parciado.push(respuesta)
  #     else
  #       @json_parciado = respuesta
  #     end
  #     JdeVehiclesLog.create(
  #       fecha: Time.zone.now.to_date,
  #       hora: Time.zone.now,
  #       json_enviado: hash_principal,
  #       respuesta: @json_parciado,
  #       vehicle_id: vehicle.id,
  #       tipo: "Modificación",
  #       trailer_id: hash_vehiculo["noEconomicoRem"]
  #     )
  #     puts @json_parciado
  #   end
    
  # end
  
  def self.actualizar_vehiculo_jde(id_vehiculo)
    vehicle = Vehicle.find_by(id: id_vehiculo)
    remolque = nil
    arreglo = Array.new
    hash_vehiculo = Hash.new
    hash_remolque = Hash.new
    hash_secundario = Hash.new
    hash_principal = Hash.new
    if vehicle.reparto == true
      repartoveh = 1
    elsif vehicle.reparto == false
      repartoveh = 0
    else
      repartoveh = "NA"
    end
    
    hash_vehiculo["noEconomico"]              = vehicle.numero_economico
    hash_vehiculo["Compania"]                 = vehicle.catalog_company.clave
    hash_vehiculo["TipoUnidad"]                = vehicle.vehicle_type.clave
    hash_vehiculo["placaVehicular"]             = vehicle.numero_placa
    hash_vehiculo["anoModelo"]                = vehicle.catalog_model.descripcion
    hash_vehiculo["noPoliza"]                  = vehicle.numero_poliza
    hash_vehiculo["licencia"]                   = vehicle.numero_licencia
    hash_vehiculo["permisoSCT"]               = vehicle.permission_type ? vehicle.permission_type.clave : "NA"
    hash_vehiculo["configVehicular"]            = vehicle.vehicle_configuration ? vehicle.vehicle_configuration.clave : "NA"
    #hash_vehiculo["subtipoRemolque"]           = vehicle.trailer_subtype ? vehicle.trailer_subtype.clave : "NA"
    hash_vehiculo["subtipoRemolque"]           = vehicle.trailer_subtype ? vehicle.trailer_subtype.clave : ""
    hash_vehiculo["numeroPermisoSCT"]        = vehicle.permiso_sat ? vehicle.permiso_sat : "NA"
    hash_vehiculo["nombreAseguradora"]        = vehicle.numero_aseguradora ? vehicle.numero_aseguradora : "NA"
    hash_vehiculo["cedis"]                      = vehicle.catalog_branch.clave_jd
    hash_vehiculo["area"]                      = vehicle.catalog_area.abreviacion
    hash_vehiculo["responsable"]               = vehicle.catalog_personal.clave
    hash_vehiculo["cobertura"]                 = vehicle.policy_coverage.clave
    hash_vehiculo["unidadRemolque"]           = vehicle.vehicle_type.clave == "010" ? 1 : 0
    hash_vehiculo["estatus"]                    = vehicle.vehicle_status.nombre == "Inac" ? 0 : 1
    hash_vehiculo["noEconomicoRem"]           = remolque ? remolque.numero_economico : "NA"
    hash_vehiculo["reparto"]                    = repartoveh
    arreglo.push(hash_vehiculo)
    hash_secundario["Vehiculo"]                 = arreglo
    hash_principal["vehiculoInput"]              = hash_secundario
    paremetro_nombre = Parameter.find_by(nombre:"Url Carta Porte")
    if paremetro_nombre
      url = URI(paremetro_nombre.valor_extendido)
      https = Net::HTTP.new(url.host, url.port);
      request = Net::HTTP::Put.new(url)
      request["Content-Type"] = "application/json"
      request["Accept"] = "application/json"
      request.body = hash_principal.to_json
      response = https.request(request)
      @json_parciado = []
      respuesta = JSON.parse response.body
      if respuesta[0].nil?
        @json_parciado.push(respuesta)
      else
        @json_parciado = respuesta
      end
      JdeVehiclesLog.create(
        fecha: Time.zone.now.to_date,
        hora: Time.zone.now,
        json_enviado: arreglo,
        respuesta: @json_parciado,
        vehicle_id: vehicle.id,
        tipo: "Modificación",
        trailer_id: hash_vehiculo["noEconomicoRem"]
      )
      puts @json_parciado
      if @json_parciado.map{|x| x['Exitoso']}.include?(false)
        return false, @json_parciado
      else
        return true, ["Satisfactorio"]
      end
    else
      return false, ["El parámetro de envío de vehículos a JD Edwards no ha sido registrado."]
    end
  end

end
