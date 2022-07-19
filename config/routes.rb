Rails.application.routes.draw do
  resources :test_vehicles
  resources :insurance_policies
  resources :valuations
  resources :jde_logs
  resources :deadlines
  resources :vehicle_logs
  resources :vehicle_items
  resources :concept_services
  resources :questions
  resources :answers
  resources :catalog_tires_batteries
  resources :ticket_tire_batteries
  resources :parameters
  resources :sections
  get 'budgets/index'
  resources :maintenance_tickets
  resources :maintenance_frecuencies
  resources :agency_mileage_indicators
  resources :workshop_certifications
  resources :review_workshops
  get 'catalog_branches_users/index'
  resources :service_orders
  resources :maintenance_programs
  resources :maintenance_appointments
  resources :mileage_indicators
  resources :maintenance_logs
  resources :mechanical_reviews
  resources :catalog_considerations
  resources :expense_vehicle_types
  resources :tuning_prices
  resources :monthly_yields
  resources :maintenance_controls
  resources :insurance_report_tickets
  resources :catalog_workshops
  resources :consumptions
  resources :accumulated_fuels
  resources :vehicle_consumptions
  resources :budget_administrations
  resources :budget_delivery_replacements
  resources :budget_sales_replacements
  resources :delivery_addresses
  resources :deliveries
  resources :customers
  resources :budget_distributions
  resources :reasons
  resources :purchase_orders
  resources :perform_targets
  resources :accounting_impacts
  resources :competition_tables
  resources :vehicle_indicators
  get 'users', to: "users#index", as: "users"
  post "/create_new_user", to: "users#create_new_user", as: "create_new_user"
  patch "/update", to: "users#update", as: "update"
  # get 'users/destroy'
  
  resources :user_vehicles
  devise_for :users
  resources :type_sinisters
  resources :catalog_responsives
  resources :catalogo_adaptations
  resources :catalog_areas
  resources :fuel_budgets
  resources :vehicle_prices
  resources :vehicle_permits
  
  resources :vehicle_models
  resources :vehicle_checklists
  resources :catalog_branches
  resources :catalog_models
  resources :catalog_brands
  resources :catalog_roles
  resources :catalog_licences
  resources :catalog_personals
  resources :catalog_vendors
  resources :vehicles
  resources :cost_centers
  resources :insurance_beneficiaries
  resources :policy_coverages
  resources :billed_companies
  resources :responsables
  resources :catalog_repairs
  resources :vehicle_statuses
  resources :vehicle_types
  resources :plate_states
  resources :catalog_routes
  resources :budget_concepts
  resources :order_service_types
  resources :vehicle_brands
  resources :branch_offices
  resources :catalog_companies
  resources :movil_api
  resources :warehouses
  #expediente
  post 'uploads/:id', to: "vehicles#uploads",as: "uploads"
  get 'ver_documentos/:id', to: "vehicles#ver_documentos",as: "ver_documentos"
  get 'document_detail/:file_id', to: "vehicles#document_detail",as: "document_detail"

  get 'borrar_firma/:id',to: "parameters#borrar_firma", as: "borrar_firma"
  post 'img_ticket_taller',to: "movil_api#img_ticket_taller"
  get 'ver_ticket_taller/:maintenance_ticket_id',to: "movil_api#ver_ticket_taller"
  post 'bimonthly_img', to: "movil_api#bimonthly_img"
  get 'ver_biomonthly_img/:bimonthly_verification_id', to: "movil_api#bimonthly_img"
  post 'cargar_imagen_licencia', to: "movil_api#cargar_imagen_licencia"
  post 'cargar_imagen_siniestro', to: "movil_api#cargar_imagen_siniestro"
  get 'ver_firma_usuario/:user_id', to: "movil_api#ver_firma_usuario"
  post 'firma_usuario', to: "movil_api#firma_usuario"
  get 'ver_licencias/:user_id', to: "movil_api#ver_licencias"
  get 'ver_evidencia_check/:checklist_response_id', to: "movil_api#ver_evidencia_check"
  put 'firma_venta/:vehicle_id', to: "movil_api#firma_venta"
  get 'ver_firma_venta/:vehicle_id', to: "movil_api#ver_firma_venta"
  post 'agregar_img_llantas', to: "movil_api#agregar_img_llantas"
  get 'ver_img_llantas/:ticket_tire_battery_id', to: "movil_api#ver_img_llantas"
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  # root to: 'home#login'
  #Maestro de vehiculos
  root to: "vehicles#index"
  post '/import_vehicles', to: 'vehicles#import_vehicles', as: "import_vehicles"
  get '/template_download_vehicles', to: 'vehicles#template_download_vehicles', as: "template_download_vehicles"
  get 'generar_excel', to: "vehicles#generar_excel", as: "generar_excel"
  get 'cancelar_compra/:id',to: "vehicles#cancelar_compra", as: "cancelar_compra"
  get 'listado_checklist/:id',to: "vehicles#listado_checklist", as: "listado_checklist"
  get 'detalle_checklist/:checklist_id',to: "vehicles#detalle_checklist", as: "detalle_checklist"
  get 'detalle_auditoria/:auditoria_id',to: "vehicles#detalle_auditoria", as: "detalle_auditoria"
  get 'vehicle_expenses/:id',to: "vehicles#vehicle_expenses", as: "vehicle_expenses"
  post 'gastos_vehiculo_x_fecha/:id',to: "vehicles#gastos_vehiculo_x_fecha", as: "gastos_vehiculo_x_fecha"
  #orden de compra
  get 'purchase_orders/:id/imprimir', to: "purchase_orders#imprimir", as: "orden_imprimir"
  get 'documentos_orden/:id', to: "purchase_orders#documentos_orden", as: "documentos_orden"
  post 'cargar_documento_orden', to: "purchase_orders#cargar_documento_orden", as: "cargar_documento_orden"
  get 'factura_orden/:id', to: "purchase_orders#factura_orden", as: "factura_orden"
  post 'cargar_factura_orden', to: "purchase_orders#cargar_factura_orden", as: "cargar_factura_orden"
  post '/filtrado_ordenes', to: "purchase_orders#filtrado_ordenes", as: "filtrado_ordenes"
  get "/nueva_orden", to: "purchase_orders#nueva_orden", as:"nueva_orden"
  post "/crear_orden", to: "purchase_orders#crear_orden", as:"crear_orden"
  get 'formulario_agregar_detalle_orden', to: "purchase_orders#formulario_agregar_detalle_orden", as: "formulario_agregar_detalle_orden"
  post "/guardar_detalle_orden", to: "purchase_orders#guardar_detalle_orden", as:"guardar_detalle_orden"
  post '/guardar_total', to: "purchase_orders#guardar_total", as: "guardar_total"
  get 'eliminar_partida_orden/:id_partida', to:"purchase_orders#eliminar_partida_orden", as: "eliminar_partida_orden"
  get 'purchase_orders/:id/imprimir_orden', to: "purchase_orders#show", as: "imprimir_orden"
  
  #rutas presupuestos para venta
  get "/nuevo_presupuesto", to: "budget_concepts#nuevo_presupuesto", as:"nuevo_presupuesto"
  post "/crear_presupuesto", to: "budget_concepts#crear_presupuesto", as:"crear_presupuesto"
  get 'formulario_agregar_detalle', to: "budget_concepts#formulario_agregar_detalle", as: "formulario_agregar_detalle"
  post "/guardar_detalle", to: "budget_concepts#guardar_detalle", as:"guardar_detalle"
  get 'eliminar_partida/:id_partida', to:"budget_concepts#eliminar_partida", as: "eliminar_partida"
  get 'budget_concepts/:id/imprimir_pres', to: "budget_concepts#show", as: "presupuesto_pdf_imprimir"
  get 'solicitar_presupuesto_venta/:id', to: "budget_concepts#solicitar_presupuesto_venta", as: "solicitar_presupuesto_venta"
  get 'borrar_presupuesto_venta/:id',to: "budget_concepts#borrar_presupuesto_venta", as: "borrar_presupuesto_venta"
  
  # secciones- area
  get "/asignar_area/:id", to: "sections#asignar_area", as:"asignar_area"
  post "/guardar_area/:id", to: "sections#guardar_area", as:"guardar_area"
  get "/ver_areas/:id", to: "sections#ver_areas", as:"ver_areas"
  get 'borrar_area/:id_area,:id_section', to: "sections#borrar_area", as: "borrar_area"
  
  #rutas presupuestos para reparto
  get "/nuevo_pres_reparto", to: "budget_distributions#nuevo_pres_reparto", as:"nuevo_pres_reparto"
  post "/crear_presupuesto_reparto", to: "budget_distributions#crear_presupuesto_reparto", as:"crear_presupuesto_reparto"
  get 'formulario_agregar_detalle_reparto', to: "budget_distributions#formulario_agregar_detalle_reparto", as: "formulario_agregar_detalle_reparto"
  post "/guardar_detalle_reparto", to: "budget_distributions#guardar_detalle_reparto", as:"guardar_detalle_reparto"
  get 'eliminar_partida_reparto/:id_partida', to:"budget_distributions#eliminar_partida_reparto", as: "eliminar_partida_reparto"
  get 'budget_distributions/:id/imprimir', to: "budget_distributions#show", as: "presupuesto_imprimir"
  get 'solicitar_presupuesto_reparto/:id', to: "budget_distributions#solicitar_presupuesto_reparto", as: "solicitar_presupuesto_reparto"
  get 'borrar_presupuesto_reparto/:id',to: "budget_distributions#borrar_presupuesto_reparto", as: "borrar_presupuesto_reparto"
  
  #rutas presupuestos para administracion
  get "/nuevo_presupuesto_admin", to: "budget_administrations#nuevo_presupuesto_admin", as:"nuevo_presupuesto_admin"
  post "/crear_presupuesto_admin", to: "budget_administrations#crear_presupuesto_admin", as:"crear_presupuesto_admin"
  get 'solicitar_presupuesto_admin/:id', to: "budget_administrations#solicitar_presupuesto_admin", as: "solicitar_presupuesto_admin"
  get 'borrar_presupuesto_admin/:id',to: "budget_administrations#borrar_presupuesto_admin", as: "borrar_presupuesto_admin"
  
  #cargar factura 
  get 'documentos_factura/:id_consumo', to: "consumptions#documentos_factura", as: "documentos_factura"
  post 'cargar_factura', to: "consumptions#cargar_factura", as: "cargar_factura"
  get 'cancelar_encabezado/:folio', to: "consumptions#cancelar_encabezado", as: "cancelar_encabezado"
  get 'documentos_pdf/:id_consumo', to: "consumptions#documentos_pdf", as: "documentos_pdf"
  post 'cargar_pdf', to: "consumptions#cargar_pdf", as: "cargar_pdf"
  post 'solicitar_autorizacion/:folio', to: "consumptions#solicitar_autorizacion", as: "solicitar_autorizacion"
  post 'solicitar_autorizacion8/:folio', to: "consumptions#solicitar_autorizacion8", as: "solicitar_autorizacion8"
  post 'solicitar_autorizacion16/:folio', to: "consumptions#solicitar_autorizacion16", as: "solicitar_autorizacion16"
  get 'borrar_carga/:id',to: "consumptions#borrar_carga", as: "borrar_carga"
  get '/ver_encabezado/:consumption_id', to: "consumptions#ver_encabezado", as: "ver_encabezado"
  get '/imprimir_encabezado_excel/:consumption_id', to: "consumptions#imprimir_encabezado_excel", as: "imprimir_encabezado_excel"
  get '/generar_reporte/:consumption_id', to: "consumptions#generar_reporte", as: "generar_reporte"
  
  get 'consumo_excel/::consumption_id', to: "consumptions#consumo_excel", as: "consumo_excel"
  get '/indice_solicitud', to: 'consumptions#indice_solicitud', as: "indice_solicitud"
  post 'busqueda_solicitud', to: 'consumptions#busqueda_solicitud', as: 'busqueda_solicitud'
  get '/ver_solicitud/:consumption_id', to: "consumptions#ver_solicitud", as: "ver_solicitud"
  get 'descargar_factura/:id_consumo', to: "consumptions#descargar_factura", as: "descargar_factura"
  get 'descargar_pdf/:id_consumo', to: "consumptions#descargar_pdf", as: "descargar_pdf"
  
  
  get 'formulario_agregar_detalle_admin', to: "budget_administrations#formulario_agregar_detalle_admin", as: "formulario_agregar_detalle_admin"
  post "/guardar_detalle_admin", to: "budget_administrations#guardar_detalle_admin", as:"guardar_detalle_admin"
  get 'eliminar_partida_admin/:id_partida', to:"budget_administrations#eliminar_partida_admin", as: "eliminar_partida_admin"
  get 'budget_administrations/:id/imprimir_ad', to: "budget_administrations#show", as: "presupuesto_imprimir_admin"
  
  get 'dashboard', to: "home#dashboard", as: "dashboard" 
  
  post '/import_consumption', to: 'vehicle_consumptions#import_consumption', as: "import_consumption"
  get '/template_download_consumption', to: 'vehicle_consumptions#template_download_consumption', as: "template_download_consumption"
  get 'cambio_usuario/:id', to: "consumptions#modal_cambio_usuario", as: "modal_cambio_usuario"
  patch 'editar_usuario/:id', to: "consumptions#editar_usuario_aut", as: "editar_usuario_aut"
  get 'cambio_factura/:id', to: "consumptions#modal_cambio_factura", as: "modal_cambio_factura"
  patch 'editar_factura/:id', to: "consumptions#editar_factura", as: "editar_factura"
  get 'consumptions/:consumption_id,:iva/imprimir_solicitud', to: "consumptions#imprimir_solicitud", as: "imprimir_solicitud"
  # 7.23.	Registro de tickets reportados por aseguradora
  post '/consulta_numero_serie', to: "insurance_report_tickets#consulta_vehiculo_serie", as: "consulta_numero_serie_siniestrabilidad"
  get '/generar_ticket_siniestrabilidad/:id', to: "insurance_report_tickets#generar_ticket_siniestrabilidad", as: "generar_ticket_siniestrabilidad"
  get '/reporte_tickets_siniestrabilidad_excel', to: "insurance_report_tickets#reporte_tickets_siniestrabilidad_excel", as: "reporte_tickets_siniestrabilidad_excel"
  post '/filtrado_tickets_aseguradora', to: "insurance_report_tickets#filtrado_tickets_aseguradora", as: "filtrado_tickets_aseguradora"
  get '/corte_ticket_aseguradora', to: "insurance_report_tickets#corte_ticket_aseguradora", as: "corte_ticket_aseguradora"
  get 'corte_ticket/:id', to: "insurance_report_tickets#corte_ticket", as: "corte_ticket"
  get 'reabrir_ticket/:id', to: "insurance_report_tickets#reabrir_ticket", as: "reabrir_ticket"
  
  # 2.28 Reporte de incidencias por responsable de siniestro
  get '/responsible_incident_report', to: "responsible_incident_report#index", as: "responsible_incident_reports"
  post '/filtrado_incidentes', to: "responsible_incident_report#filtrado_incidentes", as: "filtrado_incidentes"
  get '/responsible_incident_excel', to: "responsible_incident_report#excel_incidentes", as: "responsible_incident_excel"
  
  # 2.29 Informe de siniestrabilidad
  get 'claim_report', to: "claim_report#index", as: "claim_report"
  post 'filtro_informe_sin', to: "claim_report#filtro_informe_sin", as: "filtro_informe_sin"
  get 'abrir_modal_prima', to: "claim_report#abrir_modal_prima", as: "abrir_modal_prima"
  post 'registrar_prima_inf', to: "claim_report#registrar_prima_inf", as: "registrar_prima_inf"
  get 'abrir_modal_comparativo_informe', to: "claim_report#abrir_modal_comparativo_informe", as: "abrir_modal_comparativo_informe"
  post 'filtro_informe_sin_comparativo', to: "claim_report#filtro_informe_sin_comparativo", as: "filtro_informe_sin_comparativo"
  get '/claim_report_excel', to: "claim_report#excel_informe_sin", as: "claim_report_excel"
  get '/claim_report_excel_com', to: "claim_report#excel_informe_sin_com", as: "claim_report_excel_com"
  
  # 2.30 Indicador flotilla siniestrada
  get 'damaged_vehicle_indicators', to: "damaged_vehicle_indicators#index", as: "damaged_vehicle_indicators"
  post 'filtrado_indicadores_daniado', to: "damaged_vehicle_indicators#filtrado_indicadores_daniado", as: "filtrado_indicadores_daniado"
  get 'damaged_vehicle_indicators_excel', to: "damaged_vehicle_indicators#indicadores_daniado_excel", as: "damaged_vehicle_indicators_excel"
  
  # 2.31 Indicador monto flotilla siniestrada
  get 'damaged_vehicle_ammount_indicators', to: "damaged_vehicle_ammount_indicators#index", as: "damaged_vehicle_ammount_indicators"
  post 'filtrado_indicadores_monto', to: "damaged_vehicle_ammount_indicators#filtrado_indicadores_monto", as: "filtrado_indicadores_monto"
  get 'damaged_vehicle_ammount_indicators_excel', to: "damaged_vehicle_ammount_indicators#indicadores_monto_excel", as: "damaged_vehicle_ammount_indicators_excel"

  # 2.32 Indicador porcentaje siniestralidad
  get 'damaged_percentage_indicators', to: "damaged_percentage_indicators#index", as: "damaged_percentage_indicators"
    post 'filtrado_indicadores_porcentaje', to: "damaged_percentage_indicators#filtrado_indicadores_porcentaje", as: "filtrado_indicadores_porcentaje"
    get 'damaged_percentage_indicators_excel', to: "damaged_percentage_indicators#indicadores_porcentaje_excel", as: "damaged_percentage_indicators_excel"
  #Inidicador cantidad
  get 'claims_branch_indicator', to: "insurance_report_tickets#claims_branch_indicator", as: "claims_branch_indicator"
  post 'filtrado_indicadores_cedis', to: "insurance_report_tickets#filtrado_indicadores_cedis", as: "filtrado_indicadores_cedis"

  
    # Consulta de cedis por empresa
    post 'cedis_x_empresa_siniestralidad', to: "catalog_branches#cedis_x_empresa_siniestralidad", as: "cedis_x_empresa_siniestralidad"
    post 'cedis_x_empresa_centro', to: "catalog_branches#cedis_x_empresa_centro", as: "cedis_x_empresa_centro"
    post 'cedis_x_empresa_vehiculo', to: "catalog_branches#cedis_x_empresa_vehiculo", as: "cedis_x_empresa_vehiculo"
    post 'cedis_x_empresa_taller', to: "catalog_branches#cedis_x_empresa_taller", as: "cedis_x_empresa_taller"
    post 'cedis_x_empresa_lista', to: "catalog_branches#cedis_x_empresa_lista", as: "cedis_x_empresa_lista"
    post 'cedis_x_empresa_gasto', to: "catalog_branches#cedis_x_empresa_gasto", as: "cedis_x_empresa_gasto"
    post 'cedis_x_centro', to: "cost_centers#cedis_x_centro", as: "cedis_x_centro"
    
    
    
    #control de mantenimiento
    post 'cargar_xml', to: "maintenance_controls#cargar_xml", as: "cargar_xml"
    post 'importar_gastos_mantenimiento', to: "maintenance_controls#importar_gastos_mantenimiento", as: "importar_gastos_mantenimiento"
    get '/control_mantenimiento_excel', to: "maintenance_controls#control_mantenimiento_excel", as: "control_mantenimiento_excel"
    
    #venta
    get 'vehicles/:id/venta', to: "vehicles#venta", as: "venta_vehiculo"
  get 'registrar_encabezado/:id', to: "vehicles#registrar_encabezado", as: "registrar_encabezado"
  post 'guardar_encabezado/:id', to: "vehicles#guardar_encabezado", as: "guardar_encabezado"
  get 'registrar_costos/:id', to: "vehicles#registrar_costos", as: "registrar_costos"
  post 'guardar_costos/:id', to: "vehicles#guardar_costos", as: "guardar_costos"
  get 'registrar_mantenimiento/:id', to: "vehicles#registrar_mantenimiento", as: "registrar_mantenimiento"
  post 'guardar_mantenimiento/:id', to: "vehicles#guardar_mantenimiento", as: "guardar_mantenimiento"
  get 'solicitar_venta/:id', to: "vehicles#solicitar_venta", as: "solicitar_venta"
  get 'vehicles/:vehicle_id/imprimir_formato_venta', to: "vehicles#imprimir_formato_venta", as: "imprimir_formato_venta"
  get 'cancelar_venta/:id',to: 'vehicles#cancelar_venta', as:"cancelar_venta"
  get 'vehicle_files/:id', to: "vehicles#vehicle_files", as: "vehicle_files"
  post 'upload_document/:id_vehicle', to: "vehicles#upload_document", as: "upload_document"
  get 'destroy_vehicle_file/:file_id', to: "vehicles#destroy_vehicle_file", as: "destroy_vehicle_file"

  get 'carga_general_documentos', to: "general_vehicle_files#index", as: "carga_general_documentos"
  get 'buscar_vehiculo_carga_doc/:id_vehicle', to: "general_vehicle_files#buscar_vehiculo_carga_doc", as: "buscar_vehiculo_carga_doc"
  get 'destroy_general_vehicle_file/:file_id,:tipo', to: "general_vehicle_files#destroy_vehicle_file", as: "destroy_general_vehicle_file"
  #licencias
  get 'fotos_anverso/:id', to: "catalog_licences#fotos_anverso", as: "fotos_anverso"
  post 'cargar_fotos_anverso', to: "catalog_licences#cargar_fotos_anverso", as: "cargar_fotos_anverso"
  get 'fotos_reverso/:id', to: "catalog_licences#fotos_reverso", as: "fotos_reverso"
  post 'cargar_fotos_reverso', to: "catalog_licences#cargar_fotos_reverso", as: "cargar_fotos_reverso"
  #reporte de rendimiento y indicador
  get '/reporte_mensual', to: 'vehicle_consumptions#reporte_mensual', as: "reporte_mensual"
  post '/import_yields', to: 'monthly_yields#import_yields', as: "import_yields"
  get '/template_download_yields', to: 'monthly_yields#template_download_yields', as: "template_download_yields"
  get '/indicador_rendimiento', to: 'vehicle_consumptions#indicador_rendimiento', as: "indicador_rendimiento"
  post 'filtrado_indicadores', to: "vehicle_consumptions#filtrado_indicadores", as: "filtrado_indicadores"
  get '/rendimiento_excel', to: "vehicle_consumptions#rendimiento_excel", as: "rendimiento_excel"
  
  #reporte acumulado y indicador
  get '/reporte_acumulado', to: 'vehicle_consumptions#reporte_acumulado', as: "reporte_acumulado"
  get 'detalle/:vehicle_id', to: "vehicle_consumptions#detalle", as: "detalle_reporte"
  get 'generar_excel_acumulado', to: "vehicle_consumptions#generar_excel_acumulado", as: "generar_excel_acumulado"
  
  get '/indicador_presupuesto', to: 'vehicle_consumptions#indicador_presupuesto', as: "indicador_presupuesto"
  post 'filtrado_acumulado', to: "vehicle_consumptions#filtrado_acumulado", as: "filtrado_acumulado"
  get '/indicador_km', to: 'vehicle_consumptions#indicador_km', as: "indicador_km"
  post 'filtrado_km', to: "vehicle_consumptions#filtrado_km", as: "filtrado_km"
  post 'filtrado_acumulado_combustible', to: "vehicle_consumptions#filtrado_acumulado_combustible", as: "filtrado_acumulado_combustible"
  #bitacora de mantenimiento
  get "/nuevo_mantenimiento", to: "maintenance_logs#nuevo_mantenimiento", as:"nuevo_mantenimiento"
  post "/crear_mantenimiento", to: "maintenance_logs#crear_mantenimiento", as:"crear_mantenimiento"
  get 'formulario_agregar_mantenimiento_detalle', to: "maintenance_logs#formulario_agregar_mantenimiento_detalle", as: "formulario_agregar_mantenimiento_detalle"
  post "/guardar_detalle_mantenimiento", to: "maintenance_logs#guardar_detalle_mantenimiento", as:"guardar_detalle_mantenimiento"
  get 'eliminar_detalle/:id_partida', to:"maintenance_logs#eliminar_detalle", as: "eliminar_detalle"
  
  # seguridad
  #post "/create_new_user", to: "users#create_new_user", as: "create_new_user"
  #patch "/update", to: "users#update", as: "update"
  get   "/ajax_seguridad_permisos/:id_rol/", to: "users#ajax_seguridad_permisos", as: "seguridad_permisos"
  post  "/ajax_seguridad_permisos/:id_rol/add", to: "users#ajax_seguridad_add_permisos", as: "seguridad_add_permisos"
  get 'desactivar_usuario/:id_usuario', to: "users#desactivar_usuario", as: "desactivar_usuario"
  
  # roles
  get 'assign_permissions/:id', to: "catalog_roles#assign_permissions", as: "assign_permissions"
  get 'recarga_datatable_rol', to: "catalog_roles#recarga_datatable_rol", as: "recarga_datatable_rol"
  #CEDIS por usuarios 
  get 'catalog_branches_users', to: "catalog_branches_users#index", as: "users_branches"
  get 'assign_cedis', to: "catalog_branches_users#modal_asignar_cedis", as: "modal_asignar_cedis"
  post 'create_catalog_branches_users', to: "catalog_branches_users#asignar_cedis", as: "asignar_cedis"
  get 'delete_catalog_branches_users/:id_user,:id_cedis', to: "catalog_branches_users#eliminar_cedis_asignado", as: "eliminar_cedis_asignado"
  get 'recarga_datatable_cedis_usuario', to: "catalog_branches_users#recarga_datatable_cedis_usuario", as: "recarga_datatable_cedis_usuario"
  # Roles de usuarios
  get 'catalog_roles_users', to: "catalog_roles_users#index", as: "users_rols"
  get 'assign_rol', to: "catalog_roles_users#modal_asignar_rol", as: "modal_asignar_rol"
  get 'delete_catalog_roles_users/:id_user,:id_rol', to: "catalog_roles_users#eliminar_rol_asignado", as: "eliminar_rol_asignado"
  post 'create_catalog_roles_users', to: "catalog_roles_users#asignar_rol", as: "asignar_rol"
  get 'recarga_datatable_rol_usuario', to: "catalog_roles_users#recarga_datatable_rol_usuario", as: "recarga_datatable_rol_usuario"
  #reportes 
  get '/reporte_responsivas', to: 'vehicles#reporte_responsivas', as: "reporte_responsivas"
  get '/reporte_responsivas_detalle/:catalog_branch_id/:responsable_id/:catalog_area_id', to: 'vehicles#reporte_responsivas_detalle', as: "reporte_responsivas_detalle"
  get 'reporte/:catalog_branch_id/:responsable_id/:catalog_area_id/imprimir_reporte', to: "vehicles#reporte", as: "imprimir_reporte"
  get 'generar_excel_responsivas', to: "vehicles#generar_excel_responsivas", as: "generar_excel_responsivas"

  #orden de servicio- preventivo
  get 'asignar_taller/:id', to: "service_orders#asignar_taller", as: "asignar_taller"
  post 'guardar_taller/:id', to: "service_orders#guardar_taller", as: "guardar_taller"
  post '/consulta_taller', to: "service_orders#consulta_taller", as: "consulta_taller_mantenimiento"
  get 'autorizar_orden/:id', to: "service_orders#autorizar_orden", as: "autorizar_orden"
  get 'cancelar_orden/:id', to: "service_orders#cancelar_orden", as: "cancelar_orden"
  get 'agregar_motivo_cancelacion/:id', to: "service_orders#agregar_motivo_cancelacion", as: "motivo_cancelacion"
  post 'guardar_motivo/:id', to: "service_orders#guardar_motivo", as: "guardar_motivo"
  get 'reagendar_orden/:id', to: "service_orders#reagendar_orden", as: "reagendar_orden"
  post 'guardar_fecha_propuesta/:id', to: "service_orders#guardar_fecha_propuesta", as: "guardar_fecha_propuesta"
  get 'registrar_salida/:id', to: "service_orders#registrar_salida", as: "registrar_salida"
  post 'guardar_fecha_salida/:id', to: "service_orders#guardar_fecha_salida", as: "guardar_fecha_salida"
  get 'pdf_orden/:id', to: "service_orders#pdf_orden", as: "pdf_orden"
  post 'cargar_pdf_orden', to: "service_orders#cargar_pdf_orden", as: "cargar_pdf_orden"
  get 'factura_servicio_orden/:id', to: "service_orders#factura_servicio_orden", as: "factura_servicio_orden"
  post 'cargar_factura_servicio', to: "service_orders#cargar_factura_servicio", as: "cargar_factura_servicio"
  get 'cotizacion_servicio_orden/:id', to: "service_orders#cotizacion_servicio_orden", as: "cotizacion_servicio_orden"
  post 'cargar_cotizacion_servicio', to: "service_orders#cargar_cotizacion_servicio", as: "cargar_cotizacion_servicio"
  get 'registrar_servicio/:id', to: "service_orders#registrar_servicio", as: "registrar_servicio"
  post 'guardar_servicio/:id', to: "service_orders#guardar_servicio", as: "guardar_servicio"
  post 'solicitar_servicio/:id', to: "service_orders#solicitar_servicio", as: "solicitar_servicio"
  get 'binnacle/:id_order', to: "service_orders#binnacle", as: "binnacle"
  get 'autorizar_servicio_adicional/:id', to: "service_orders#autorizar_servicio_adicional", as: "autorizar_servicio_adicional"
  get 'rechazar_servicio_adicional/:id', to: "service_orders#rechazar_servicio_adicional", as: "rechazar_servicio_adicional"
  get 'crear_cotizacion/:id',to: "service_orders#crear_cotizacion", as: "crear_cotizacion"
  get 'detalle_cotizacion/:quote_id',to: "service_orders#detalle_cotizacion", as: "detalle_cotizacion"
  post 'guardar_detalle_cotizacion/:quote_id', to: "service_orders#guardar_detalle_cotizacion", as: "guardar_detalle_cotizacion"
  post 'solicitar_cotizacion/:quote_id', to: "service_orders#solicitar_cotizacion", as: "solicitar_cotizacion"
  get 'ver_cotizacion/:id', to: "service_orders#ver_cotizacion", as: "ver_cotizacion"
  get 'autorizar_cotizacion/:id', to: "service_orders#autorizar_cotizacion", as: "autorizar_cotizacion"
  get 'rechazar_cotizacion/:id', to: "service_orders#rechazar_cotizacion", as: "rechazar_cotizacion"
  get 'finalizar_servicio/:id', to: "service_orders#finalizar_servicio", as: "finalizar_servicio"
  post 'registrar_control/:id', to: "service_orders#registrar_control", as: "registrar_control"

  #tickets 
  get 'autorizar_ticket/:id', to: "maintenance_tickets#autorizar_ticket", as: "autorizar_ticket"
  get 'rechazar_ticket/:id', to: "maintenance_tickets#rechazar_ticket", as: "rechazar_ticket"
  get 'crear_orden_ticket/:id', to: 'maintenance_tickets#crear_orden_ticket', as: "crear_orden_ticket"
  post 'guardar_orden_ticket/:id', to: "maintenance_tickets#guardar_orden_ticket", as: "guardar_orden_ticket"
  get 'ver_fotos_tickets/:id', to: "maintenance_tickets#ver_fotos_tickets", as: "ver_fotos_tickets"

  #indicador horas taller
  get '/indicador_horas_taller', to: 'maintenance_controls#indicador_horas_taller', as: "indicador_horas_taller"
  post 'taller_x_cedis', to: "catalog_workshops#taller_x_cedis", as: "taller_x_cedis"
  post 'filtrado_horas', to: "maintenance_controls#filtrado_horas", as: "filtrado_horas"
  #indicador y reportes mmto
  get '/indicador_costo_mantenimiento', to: 'service_orders#indicador_costo_mantenimiento', as:"indicador_costo_mantenimiento"
  post 'filtrado_costos', to: "service_orders#filtrado_costos", as: "filtrado_costos"
  post 'filtrado_pres_mant', to: "maintenance_controls#filtrado_pres_mant", as: "filtrado_pres_mant"
  get '/reporte_presupuesto_mantenimiento', to: 'maintenance_controls#reporte_presupuesto_mantenimiento', as:"reporte_presupuesto_mantenimiento"
  post 'numero_x_cedis', to: "vehicles#numero_x_cedis", as: "numero_x_cedis"
  #indicador respuesta talleres
  get '/indicador_respuestas_taller', to: 'maintenance_controls#indicador_respuestas_taller', as: "indicador_respuestas_taller"
  post 'filtrado_respuestas', to: "maintenance_controls#filtrado_respuestas", as: "filtrado_respuestas"

  #solicitud de mantenimiento
  get '/generar_solicitud/:service_order_id', to: "service_orders#generar_solicitud", as: "generar_solicitud"
  post 'filtrado_gastos/:id', to: "service_orders#filtrado_gastos", as: "filtrado_gastos"
  get 'service_orders/:service_order_id/imprimir_solicitud_mmto', to: "service_orders#imprimir_solicitud_mmto", as: "imprimir_solicitud_mmto"
  
  #documentacion de talleres 
  get 'fotos_taller/:id', to: "workshop_certifications#fotos_taller", as: "fotos_taller"
  post 'cargar_fotos_taller', to: "workshop_certifications#cargar_fotos_taller", as: "cargar_fotos_taller"
  get 'comprobante_taller/:id', to: "workshop_certifications#comprobante_taller", as: "comprobante_taller"
  post 'cargar_comprobante_taller', to: "workshop_certifications#cargar_comprobante_taller", as: "cargar_comprobante_taller"
  get 'caratulas_taller/:id', to: "workshop_certifications#caratulas_taller", as: "caratulas_taller"
  post 'cargar_caratulas_taller', to: "workshop_certifications#cargar_caratulas_taller", as: "cargar_caratulas_taller"
  get 'constancia_taller/:id', to: "workshop_certifications#constancia_taller", as: "constancia_taller"
  post 'cargar_constancia_taller', to: "workshop_certifications#cargar_constancia_taller", as: "cargar_constancia_taller"
  get 'rfc_taller/:id', to: "workshop_certifications#rfc_taller", as: "rfc_taller"
  post 'cargar_rfc_taller', to: "workshop_certifications#cargar_rfc_taller", as: "cargar_rfc_taller"
  # registro - formato de alta
  get 'workshop_certifications/:workshop_certification_id/imprimir_formato_alta', to: "workshop_certifications#imprimir_formato_alta", as: "imprimir_formato_alta"
  get 'crear_ticket_taller', to: "workshop_certifications#crear_ticket_taller", as: "crear_ticket_taller"
  post 'guardar_ticket_taller', to: "workshop_certifications#guardar_ticket_taller", as: "guardar_ticket_taller"
  
  # Presupuestos
  get 'budgets', to: "budgets#index", as: "budgets"
  get 'budget/:id', to: "budgets#show", as: "show_budget"
  get 'request_budget/:id/catalog_area/:area_id', to: "budgets#request_budget", as: "request_budget"
  get 'new_budget', to: "budgets#new", as: "new_budget"
  post 'create_budget', to: "budgets#create", as: "create_budget"
  get 'budget/:id/edit', to: "budgets#edit", as: "edit_budget"
  get 'add_item_budget/:id', to: "budgets#add_item_budget", as: "add_item_budget"
  post 'save_item_budget', to: "budgets#save_item_budget", as: "save_item_budget"
  get 'edit_item_budget/:id_budget/budget_item/:id_budget_item/destroy', to: "budgets#edit_item_budget", as: "edit_item_budget"
  patch 'update_item_budget/:id_concepto', to: "budgets#update_item_budget", as: "update_item_budget"
  patch 'budget/:id/update', to: "budgets#update", as: "update_budget"
  get 'budget/:id_budget/budget_item/:id_budget_item/destroy', to: "budgets#destroy", as: "destroy_budget_item"
  post '/search_budgets_by_area', to: "budgets#search_by_area", as: "search_budgets_by_area"
  get 'pdf_budget/budget/:budget_id/area/:area_id', to: "budgets#pdf_presupuestos", as: "pdf_budget"
  
  # Autorización de presupuestos
  get 'budget_requests', to: "budget_requests#index", as: "budget_requests"
  get 'budget_requests/show', to: "budget_requests#show", as: "show_budget_requests"
  get 'accept_budget_request/:budget_id/section/:section_id', to: "budget_requests#accept_budget_request", as: "accept_budget_request"
  get 'reject_budget_request/:budget_id/section/:section_id', to: "budget_requests#reject_budget_request", as: "reject_budget_request"
  get '/show_budget_requests_concepts/:budget_id/section/:section_id', to: "budget_requests#show_budget_requests_concepts", as: "show_budget_requests_concepts"
  # adaptaciones
  get 'agregar_adaptaciones/:id', to: "vehicles#agregar_adaptaciones", as: "agregar_adaptaciones"
  post 'guardar_adaptaciones/:id', to: "vehicles#guardar_adaptaciones", as: "guardar_adaptaciones"
  get 'solicitar_adaptacion/:id', to: "vehicle_adaptations#solicitar_adaptacion", as: "solicitar_adaptacion"
  get 'pdf_adaptacion/:id', to: "vehicle_adaptations#pdf_adaptacion", as: "pdf_adaptacion"
  post 'cargar_pdf_adaptacion', to: "vehicle_adaptations#cargar_pdf_adaptacion", as: "cargar_pdf_adaptacion"
  get 'factura_adaptacion/:id', to: "vehicle_adaptations#factura_adaptacion", as: "factura_adaptacion"
  post 'cargar_factura_adaptacion', to: "vehicle_adaptations#cargar_factura_adaptacion", as: "cargar_factura_adaptacion"
  get 'cambio_factura_adaptacion/:id', to: "vehicle_adaptations#modal_cambio_factura_adaptacion", as: "modal_cambio_factura_adaptacion"
  patch 'editar_factura_adaptacion/:id', to: "vehicle_adaptations#editar_factura_adaptacion", as: "editar_factura_adaptacion"
  get 'imprimir_adaptacion/:vehicle_adaptation_id', to: "vehicles#imprimir_adaptacion", as: "imprimir_adaptacion"
  # Responsivas
  get 'responsible_reassignment/catalog_branch/:catalog_branch_id/responsible/:responsable_id/:catalog_area_id', to: "vehicles#reasignar_responsables_modal", as: "reasignar_responsables_modal"
  get 'reassing_responsible/responsible/:responsable_ant/responsible/:responsable_nvo/catalog_branch/:cedis/:catalog_area_id', to: "vehicles#reasignar_responsable", as: "reasignar_responsable"
  
  # Autorización de ordenes de compra
  get 'purchase_orders_requests', to: "purchase_orders_requests#index", as: "purchase_orders_requests"
  get 'authorize_purchase_orders_request/:id_orden', to: "purchase_orders_requests#autorizar", as: "autorizar_ordenes_compra"
  get 'reject_purchase_orders_request/:id_orden', to: "purchase_orders_requests#modal_rechazar", as: "modal_rechazar_orden_compra"
  post 'reject_purchase_order_request', to: "purchase_orders_requests#rechazar_orden_compra", as: "rechazar_orden_compra"
  
  #tickets - baterias - llantas 
  get 'autorizar_compra_ticket/:id', to: "ticket_tire_batteries#autorizar_compra_ticket", as: "autorizar_compra_ticket"
  get 'rechazar_compra_ticket/:id', to: "ticket_tire_batteries#rechazar_compra_ticket", as: "rechazar_compra_ticket"
  post 'agregar_motivo_rechazo/:id', to: "ticket_tire_batteries#agregar_motivo_rechazo", as: "agregar_motivo_rechazo"
  get 'ver_fotos/:id', to: "ticket_tire_batteries#ver_fotos", as: "ver_fotos"
  get 'generar_orden/:id', to: "ticket_tire_batteries#generar_orden", as: "generar_orden"
  post "/crear_orden_compra/:id", to: "ticket_tire_batteries#crear_orden_compra", as:"crear_orden_compra"
  
  #querys de emergencia (procesos que modifican info de DB)
  get 'emergency_querys', to: "emergency_querys#index", as: "emergency_querys"
  get 'emergency_querys_programamtto', to: "emergency_querys#programa_mtto", as: "emergency_querys_programa_mtto"
  get 'eliminar_consumos', to: "emergency_querys#eliminar_consumos", as: "eliminar_consumos"
  get 'emergency_querys_consumo_combustible', to: 'emergency_querys#importa_consumos', as: 'emergency_querys_consumo_combustible'
  get 'emergency_querys_siniestros', to: 'emergency_querys#importa_siniestros', as: 'emergency_querys_siniestros'
  get 'emergency_querys_bitacora', to: 'emergency_querys#importa_concept_brands', as: 'emergency_querys_bitacora'
  get 'emergency_querys_gastos', to: 'emergency_querys#importa_gastos_mmto', as: 'emergency_querys_gastos'
  get 'emergency_querys_presupuesto', to: 'emergency_querys#importa_presupuesto_combustible', as: 'emergency_querys_presupuesto'
  get 'importa_tipos_permiso_remolque', to: 'emergency_querys#importa_tipos_permiso_remolque', as: 'importa_tipos_permiso_remolque'
  get 'importa_subtipo_remolque', to: 'emergency_querys#importa_subtipo_remolque', as: 'importa_subtipo_remolque'
  get 'importa_configuracion_vehiculo', to: 'emergency_querys#importa_configuracion_vehiculo', as: 'importa_configuracion_vehiculo'
  post 'actualiza_programa_mtto', to: 'emergency_querys#actualiza_programa_mtto', as: 'actualiza_programa_mtto'
  post 'upload_documents_emergency', to: "emergency_querys#upload_documents_emergency", as: "upload_documents_emergency"
  get 'actualiza_km_programa_mtto', to: 'emergency_querys#actualiza_km_programa_mtto', as: 'actualiza_km_programa_mtto'
  get 'primera_carga_transfer_veh', to: "emergency_querys#primera_carga_transfer_veh", as: "primera_carga_transfer_veh"
  get 'cedis_consumo_combustible', to: "emergency_querys#cedis_consumo_combustible", as: "cedis_consumo_combustible"
  post 'importar_usuarios', to: "emergency_querys#importar_usuarios", as: "importar_usuarios"
  get 'corregir_economicos_siniestralidad', to: "emergency_querys#corregir_economicos_siniestralidad", as: "corregir_economicos_siniestralidad"

  get 'importar_frecuencias', to: "maintenance_frecuencies#importar_frecuencias", as: "importar_frecuencias"
  post 'importar_frecuencias', to: "maintenance_frecuencies#importar_frecuencias"
  
  #bitacora -conceptos
  get 'concepts/index'
  get 'concepts/new' ,as: "new_concept"
  post 'mostrar_acciones', to: "concepts#mostrar_acciones", as: "mostrar_acciones"
  get 'assign_concept_brand',to: "concepts#assign_concept_brand" ,as: "assign_concept_brand"
  post "/create_new_concept", to: "concepts#create_new_concept", as: "create_new_concept"
  get 'concepts/edit/:id',to: "concepts#edit",as: "update_concept"
  post 'save_concept/:id', to: "concepts#save_concept", as: "save_concept"
  get 'concepts/delete/:id',to: "concepts#delete",as: "delete_concept"
  get 'asign_actions/:id',to: "concepts#asign_actions",as: "asign_actions"
  post 'save_action/:id', to: "concepts#save_action", as: "save_action"
  post 'save_actions_brand/:id', to: "concepts#save_actions_brand", as: "save_actions_brand"

  get 'maintenance_concepts', to: "concepts#index_conceptos", as: "index_conceptos"
  get 'maintenance_concepts/maintenance_concept_form/new', to: "concepts#modal_nvo_concepto", as: "modal_nvo_concepto"
  get 'maintenance_concepts/maintenance_concept_form/concept/:id_concepto/edit', to: "concepts#modal_editar_concepto", as: "modal_editar_concepto"
  post 'maintenance_concepts/maintenance_concept/save', to: "concepts#guardar_concepto", as: "guardar_concepto"
  patch 'maintenance_concepts/maintenance_concept/concept/:id_concepto/update', to: "concepts#editar_concepto", as: "editar_concepto"
  post 'maintenance_concepts/maintenance_concept/import', to: "concepts#importar_conceptos", as: "importar_conceptos"
  get 'maintenance_concepts/maintenance_concept_layout/download', to: "concepts#descargar_plantilla_conceptos", as: "descargar_plantilla_conceptos"

  get 'concepts/:id_categoria/concept', to: "concepts#ver_conceptos", as: "ver_conceptos_agregados"
  get 'concepts/concept_form/new', to: "concepts#modal_nva_categoria", as: "modal_nva_categoria"
  get 'concepts/concept_form/concept/:id_categoria/edit', to: "concepts#modal_editar_categoria", as: "modal_editar_categoria"
  post 'concepts/concept/save', to: "concepts#guardar_categoria", as: "guardar_categoria"
  patch 'concepts/concept/concept/:id_categoria/update', to: "concepts#editar_categoria", as: "editar_categoria"
  post 'concepts/concept/import', to: "concepts#importar_categorias", as: "importar_categorias"
  get 'concepts/concept_layout/download', to: "concepts#descargar_plantilla_categorias", as: "descargar_plantilla_categorias"
  post 'concepts/assign_concept/:id_categoria/concept', to: "concepts#asignar_categorias", as: "asignar_categorias"
  delete 'concepts/concept/:id_categoria/delete', to: "concepts#eliminar_categoria", as: "eliminar_categoria"
  get 'concepts/frequency_layout/download', to: "concepts#plantilla_frecuencias", as: "plantilla_frecuencias"
  post 'maintenance/binnacle/import', to: "concepts#importar_bitacora_mantenimiento", as: "importar_bitacora_mantenimiento"
  delete 'maintenance_concepts/maintenance_concept/:id_concepto/delete', to: "concepts#eliminar_concepto", as: "eliminar_concepto"
  get 'concepts/:id_accion', to: "concepts#ver_servicio", as: "ver_servicios_agregados"
  post 'concepts/assign_service/:id_accion', to: "concepts#asignar_servicios", as: "asignar_servicios"
  #tablero bitacora
  get 'binnacles_index', to: "concepts#binnacles_index", as: "binnacles_index"
  post 'mostrar_bitacora', to: "concepts#mostrar_bitacora", as: "mostrar_bitacora"
  get 'update_binnacle/:id', to: "concepts#update_binnacle", as: "update_binnacle"
  post 'editar_bitacora/:id', to: "concepts#editar_bitacora", as: "editar_bitacora"
  get 'borrar_bitacora/:id',to: "concepts#borrar_bitacora", as: "borrar_bitacora"


  #historico afinaciones
  get 'tuning_log', to: "tuning_prices#tuning_log", as: "tuning_log"
  post 'tuning_prices/importar_precios', to: "tuning_prices#importar_precios", as: "importar_precios"
  get 'descargar_plantilla_precios', to: "tuning_prices#descargar_plantilla_precios", as: "descargar_plantilla_precios"

  # Reasignación, asignación y aceptación
  get 'vehicles_assignation', to: "vehicles#reasignacion_vehiculos", as: "asignacion_vehiculos"
  get 'assignation_checklist/:id_vehiculo/vehicle/:numero_economico/identifier/:vehicle_type_id/type', to: "vehicles#checklist_asignacion", as: "checklist_asignacion"
  post 'checklist_registration/:id_vehiculo/vehicle/:numero_economico/identifier/:vehicle_type_id/type', to: "vehicles#registrar_checklist_vehiculo", as: "registrar_checklist_vehiculo"
  #reporte de documentos
  get '/reporte_documentos', to: 'vehicles#reporte_documentos', as: "reporte_documentos"
  post '/filtrado_documentos', to: "vehicles#filtrado_documentos", as: "filtrado_documentos"
  #reporte auditorias
  get '/reporte_auditorias', to: 'vehicles#reporte_auditorias', as: "reporte_auditorias"
  #filtros catalogos
  post '/filtrado_frecuencias', to: "maintenance_frecuencies#filtrado_frecuencias", as: "filtrado_frecuencias"
  post '/filtrado_afectaciones', to: "accounting_impacts#filtrado_afectaciones", as: "filtrado_afectaciones"
  post '/filtrado_centros', to: "cost_centers#filtrado_centros", as: "filtrado_centros"
  post '/filtrado_llantas', to: "catalog_tires_batteries_#filtrado_llantas", as: "filtrado_llantas"
  post '/filtrado_licencias', to: "catalog_licences#filtrado_licencias", as: "filtrado_licencias"
  post '/filtrado_precios', to: "tuning_prices#filtrado_precios", as: "filtrado_precios"
  post '/filtrado_competencias', to: "competition_tables#filtrado_competencias", as: "filtrado_competencias"
  post '/filtrado_talleres', to: "catalog_workshops#filtrado_talleres", as: "filtrado_talleres"
  post '/filtrado_cargas', to: "vehicle_consumptions#filtrado_cargas", as: "filtrado_cargas"
  post '/filtrado_usuarios_cedis', to: "catalog_branches_users#filtrado_usuarios_cedis", as: "filtrado_usuarios_cedis"
  post '/filtrado_usuarios_rol', to: "catalog_roles_users#filtrado_usuarios_rol", as: "filtrado_usuarios_rol"
  post '/filtrado_ordenes_servicio', to: "service_orders#filtrado_ordenes_servicio", as: "filtrado_ordenes_servicio"
  post '/filtrado_maestro', to: "vehicles#filtrado_maestro", as: "filtrado_maestro"
  post '/filtrado_seguimiento', to: "mileage_indicators#filtrado_seguimiento", as: "filtrado_seguimiento"
  post '/filtrado_programa', to: "maintenance_programs#filtrado_programa", as: "filtrado_programa"
  post '/filtrado_tickets', to: "maintenance_tickets#filtrado_tickets", as: "filtrado_tickets"
  post '/filtrado_historico', to: "maintenance_controls#filtrado_historico", as: "filtrado_historico"
  post '/filtrado_citas', to: "maintenance_appointments#filtrado_citas", as: "filtrado_citas"
  post '/filtrado_auditorias', to: "vehicles#filtrado_auditorias", as: "filtrado_auditorias"
  get 'modal_pendientes_captura_km/:branch_id', to: "maintenance_programs#modal_pendientes_captura_km", as: "modal_pendientes_captura_km"
  post 'filtrado_reporte_mensual', to: "vehicle_consumptions#filtrado_reporte_mensual", as: "filtrado_reporte_mensual"

  # Correos
  get 'correo_incidencias_responsable_siniestro', to: "movil_api#correo_incidencias_responsable_siniestro", as: "correo_incidencias_responsable_siniestro"
  get 'consulta_siniestros_indicador_correo', to: "movil_api#consulta_siniestros_indicador_correo", as: "consulta_siniestros_indicador_correo"
  get 'correo_monto_siniestrada', to: "movil_api#correo_monto_siniestrada", as: "correo_monto_siniestrada"
  get 'correo_flotilla_siniestrada', to: "movil_api#correo_flotilla_siniestrada", as: "correo_flotilla_siniestrada"
  get 'correo_indicador_vehiculos_dentro_rendimiento', to: "movil_api#correo_indicador_vehiculos_dentro_rendimiento", as: "correo_indicador_vehiculos_dentro_rendimiento"
  get 'correo_reporte_acumulado', to: 'movil_api#correo_reporte_acumulado', as: "correo_reporte_acumulado"
  get 'correo_reporte_reparto', to: 'movil_api#correo_reporte_reparto', as: "correo_reporte_reparto"
  get 'correo_indicador_presupuesto', to: 'movil_api#correo_indicador_presupuesto', as: "correo_indicador_presupuesto"
  get 'correo_indicador_km', to: 'movil_api#correo_indicador_km', as: "correo_indicador_km"
  #exportar excel
  get 'generar_excel_programa', to: "maintenance_programs#generar_excel_programa", as: "generar_excel_programa"
  get 'generar_excel_citas', to: "maintenance_appointments#generar_excel_citas", as: "generar_excel_citas"
  get 'generar_excel_horas', to: "maintenance_controls#generar_excel_horas", as: "generar_excel_horas"
  get 'generar_excel_respuestas', to: "maintenance_controls#generar_excel_respuestas", as: "generar_excel_respuestas"
  get 'generar_excel_presupuestos', to: "budgets#generar_excel_presupuestos", as: "generar_excel_presupuestos"

  get 'ejecutar_mantenimiento', to: "maintenance_programs#ejecutar_mantenimiento", as: "ejecutar_mantenimiento_notificacion"

  # tasas
  get 'abrir_modal_nueva_tasa', to: "valuations#modal_crear", as: "modal_crear_tasa"
  get 'abrir_modal_actualizar_tasa/:valuation_id', to: "valuations#modal_editar", as: "modal_actualizar_tasa"
  post 'asignacion_tasa_cedis', to: "valuations#asignacion_tasa_cedis", as: "asignacion_tasa_cedis"
  delete 'eliminar_tasa_cedis/:valuations_branch_id', to: "valuations#eliminar_tasa_cedis", as: "delete_valuation_assignation"

  # licencias por expirar
  get 'expiring_licenses_report', to: "expiring_licenses#index", as: "expiring_licenses"
  post 'expiring_licenses_filter', to: "expiring_licenses#filtrado_licencias_expirar", as: "filtrado_licencias_expirar"
  get 'expiring_licenses_excel', to: "expiring_licenses#excel_licencias_expirar", as: "excel_licencias_expirar"

  # reporte de verificaciones
  get 'verifications_report', to: "verifications_report#index", as: "verifications_report"
  post 'verifications_report_filter', to: "verifications_report#filtrado_verificaciones", as: "filtrado_verificaciones"
  get 'verifications_report_excel', to: "verifications_report#excel_verificaciones", as: "excel_verificaciones"

  # almacenes
  get 'abrir_modal_nuevo_almacen', to: "warehouses#modal_crear", as: "modal_crear_almacen"
  get 'abrir_modal_actualizar_almacen/:warehouse_id', to: "warehouses#modal_editar", as: "modal_actualizar_almacen"

  get 'jde_vehicle_logs', to: "jde_vehicles_logs#index", as: "jde_vehicles_logs"

  post 'ccosto_x_cedis', to: "cost_centers#ccosto_x_cedis", as: "ccosto_x_cedis"

  get 'plantilla_maestro_vehiculo_completa', to: "vehicles#plantilla_maestro_vehiculo_completa", as: "plantilla_maestro_vehiculo_completa"
  post 'importar_maestro_vehiculos', to: "vehicles#importar_maestro_vehiculos", as: "importar_maestro_vehiculos"
  get 'plantilla_carta_porte', to: "vehicles#plantilla_carta_porte", as: "plantilla_carta_porte"

  get 'abrir_modal_nueva_poliza', to: "insurance_policies#modal_crear", as: "modal_crear_poliza"
  get 'abrir_modal_actualizar_poliza/:insurance_policy_id', to: "insurance_policies#modal_editar", as: "modal_actualizar_poliza"
  get 'abrir_modal_nuevo_inciso/:insurance_policy_id', to: "insurance_policies#modal_crear_inciso", as: "modal_crear_inciso"
  get 'abrir_modal_actualizar_inciso/:policy_item_id', to: "insurance_policies#modal_editar_inciso", as: "modal_actualizar_inciso"
  patch 'update_insurance_policy_item/:policy_item_id', to: "insurance_policies#actualizar_inciso", as: "actualizar_inciso"
  get 'abrir_modal_asignacion_vehiculos/:insurance_policy_id', to: "insurance_policies#activar_poliza_modal", as: "activar_poliza_modal"
  post 'buscar_vehiculos_x_asignar', to: "insurance_policies#buscar_vehiculos_x_asignar", as: "buscar_vehiculos_x_asignar"
  post 'buscar_vehiculos_asignados', to: "insurance_policies#buscar_vehiculos_asignados", as: "buscar_vehiculos_asignados"
  post 'asignar_vehiculos_poliza', to: "insurance_policies#asignar_vehiculos_poliza", as: "asignar_vehiculos_poliza"
  post 'remover_vehiculos_asignados_poliza', to: "insurance_policies#remover_vehiculos_asignados_poliza", as: "remover_vehiculos_asignados_poliza"
  post 'create_insurance_policy', to: "insurance_policies#registrar_inciso", as: "registrar_inciso"
  delete 'delete_policy_item/:policy_item_id', to: "insurance_policies#eliminar_inciso", as: "eliminar_inciso"
  get 'activate_policy/:insurance_policy_id', to: "insurance_policies#activar_poliza", as: "activar_poliza"

  get 'modal_convertir_a_taller/:id', to: "catalog_vendors#modal_convertir_a_taller", as: "modal_convertir_a_taller"
  post 'convertir_a_taller/:id', to: "catalog_vendors#convertir_a_taller", as: "convertir_a_taller"
  post 'get_modelos_articulos', to: "purchase_orders#get_modelos_articulos", as: "get_modelos_articulos"
  post 'get_precios_articulos', to: "purchase_orders#get_precios_articulos", as: "get_precios_articulos"

  get 'vista_de_prueba', to: "test_vehicles#vista_prueba", as: "vista_prueba"



  match "/404", to: "errors#not_found", via: :all
  match "/500", to: "errors#internal_server_error", via: :all

end
