connection = ActiveRecord::Base.connection()
sql = "ALTER TABLE permissions DISABLE TRIGGER ALL;"
sql2 = "ALTER TABLE permissions ENABLE TRIGGER ALL;"
ActiveRecord::Base.connection.execute(sql)
Permission.destroy_all
ActiveRecord::Base.connection.reset_pk_sequence!("permissions")
ActiveRecord::Base.connection.execute(sql2)
sql = <<-EOL

INSERT INTO public.permissions (nombre,accion,clase,descripcion,clase_id,menu,opcion,created_at,updated_at) VALUES
	 ('Ver index de consumo de vehículos','ver_index_consumo_vehiculos','VehicleConsumption','Ver index de consumo de vehículos',NULL,'Combustible','Consumo por vehículos','2020-10-05 15:24:45','2020-10-05 15:24:45'),
	 ('Subir carga de consumos','subir_carga_consumos','VehicleConsumption','Subir carga de consumos',NULL,'Combustible','Consumo por vehículos','2020-10-05 15:24:45','2020-10-05 15:24:45'),
	 ('Cargar facturas de consumos','cargar_facturas_consumos','Consumption','Cargar facturas de consumos',NULL,'Combustible','Consumo por vehículos','2020-10-05 15:24:45','2020-10-05 15:24:45'),
	 ('Cargar PDF de consumos','cargar_pdf_consumos','Consumption','Cargar PDF de consumos',NULL,'Combustible','Consumo por vehículos','2020-10-05 15:24:45','2020-10-05 15:24:45'),
	 ('Ver detalle de consumo','ver_encabezado','Consumption','Ver detalle de consumo',NULL,'Combustible','Consumo por vehículos','2020-10-05 15:24:45','2020-10-05 15:24:45'),
	 ('Ver index de consultas autorizadas','ver_index_solicitudes_aut','Consumption','Ver index de consultas autorizadas',NULL,'Combustible','Solicitudes Autorizadas','2020-10-05 15:24:45','2020-10-05 15:24:45'),
	 ('Generar reporte de consumo','generar_consumo','Consumption','Generar reporte de consumo',NULL,'Combustible','Consumo por vehículos','2020-10-05 15:24:45','2020-10-05 15:24:45'),
	 ('Solicitar autorizacion de consumo de combustible','solicitud_consumo','Consumption','Autorización de consumo semanal de combustible',NULL,'Combustible','Consumo por vehículos','2020-10-05 15:24:45','2020-10-05 15:24:45'),
	 ('Ver reporte de control de combustible acumulado','reportes_combustible_acumulado','VehicleConsumption','Ver reporte de control de combustible acumulado',NULL,'Combustible','Reporte de control de combustible acumulado','2020-10-05 15:24:45','2020-10-05 15:24:45'),
	 ('Ver reporte de rendimiento mensual','index_rendimiento_mensual_reparto','VehicleConsumption','Ver reporte de rendimiento mensual',NULL,'Combustible','Reporte de rendimiento mensual de reparto','2020-10-05 15:24:45','2020-10-05 15:24:45');
INSERT INTO public.permissions (nombre,accion,clase,descripcion,clase_id,menu,opcion,created_at,updated_at) VALUES
	 ('Ver indicador vehículos dentro de rendimiento','indicador_vehiculos_dentro_rendimiento','VehicleConsumption','Ver indicador vehículos dentro de rendimiento',NULL,'Combustible','Indicador vehículos dentro de rendimiento','2020-10-05 15:24:45','2020-10-05 15:24:45'),
	 ('Ver indicador vehículos fuera de presupuesto','indicador_vehiculos_fuera_presupuesto','VehicleConsumption','Ver indicador vehículos fuera de presupuesto',NULL,'Combustible','Indicador vehículos fuera de presupuesto','2020-10-05 15:24:45','2020-10-05 15:24:45'),
	 ('Ver indicador vehículos dentro del objetivo del gasto por km','indicador_vehiculos_objetivo_gasto','VehicleConsumption','Ver indicador vehículos dentro del objetivo del gasto por km',NULL,'Combustible','Indicador vehículos dentro del objetivo del gasto por km','2020-10-05 15:24:45','2020-10-05 15:24:45'),
	 ('Catalogo proveedores','catalogo_proveedores','CatalogVendor','Catalogo Proveedores',NULL,'Catalogos','Proveedores','2020-12-15 16:13:36','2020-12-15 16:13:36'),
	 ('Catalogo centro de costos','catalogo_centro_costos','CostCenter','Centro de costos',NULL,'Catalogos','Centro de costos','2020-12-15 16:13:36','2020-12-15 16:13:36'),
	 ('Catalogo beneficiarios','catalogo_beneficiarios','InsuranceBeneficiary','Catalogo beneficiario preferente',NULL,'Catalogos','Beneficiario preferente

','2020-12-15 16:13:36','2020-12-15 16:13:36'),
	 ('Catalogo reparaciones','catalogo_reparaciones','CatalogRepair','Catalogo reparaciones',NULL,'Catalogos','Reparaciones','2020-12-15 16:13:36','2020-12-15 16:13:36'),
	 ('Catalogo estados de plaqueo','catalogo_estados_plaqueo','PlateState','Catalogo estados de plaqueo',NULL,'Catalogos','Estados de plaqueo



','2020-12-15 16:13:36','2020-12-15 16:13:36'),
	 ('Catalogo rutas','catalogo_rutas','CatalogRoute','Catalogo rutas',NULL,'Catalogos','Rutas','2020-12-15 16:13:36','2020-12-15 16:13:36');
INSERT INTO public.permissions (nombre,accion,clase,descripcion,clase_id,menu,opcion,created_at,updated_at) VALUES
	 ('Catalogo empresas','catalogo_empresas','CatalogCompany','Catalogo empresas',NULL,'Catalogos','Empresas','2020-12-15 16:13:36','2020-12-15 16:13:36'),
	 ('Catalogo  tipos de órdenes de servicio','catalogo_tipo_orden_servicio','OrderServiceType','Catalogo  tipos de órdenes de servicio',NULL,'Catalogos','Tipo ordenes de servicio','2020-12-15 16:13:36','2020-12-15 16:13:36'),
	 ('Catalogo línea de vehículo','catalogo_lineas','CatalogBrand','Catalogo línea de vehículo',NULL,'Catalogos','Línea de vehículo','2020-12-15 16:13:36','2020-12-15 16:13:36'),
	 ('Catalogo modelos','catalogo_modelos','CatalogModel','Catalogo modelo',NULL,'Catalogos','Modelos','2020-12-15 16:13:36','2020-12-15 16:13:36'),
	 ('Catalogo CEDIS','catalogo_cedis','CatalogBranch','Catalogo CEDIS',NULL,'Catalogos','CEDIS','2020-12-15 16:13:36','2020-12-15 16:13:36'),
	 ('Catalogo personal','catalogo_personal','CatalogPersonal','Catalogo personal',NULL,'Catalogos','Personal','2020-12-15 16:13:36','2020-12-15 16:13:36'),
	 ('Catalogo licencias','catalogo_licencias','CatalogLicence','Catalogo licencias',NULL,'Catalogos','Licencias','2020-12-15 16:13:36','2020-12-15 16:13:36'),
	 ('Catalogo checklist vehículos','catalogo_checklist_vehiculos','VehicleChecklist','Catalogo checklist vehículos',NULL,'Catalogos','Checklist vehículos','2020-12-15 16:13:36','2020-12-15 16:13:36'),
	 ('Catalogo permisos de vehículos','catalogo_permisos','VehiclePermit','Catalogo permisos de vehículos',NULL,'Catalogos','Permisos vehículos','2020-12-15 16:13:36','2020-12-15 16:13:36'),
	 ('Catalogo adaptaciones','catalogo_adaptaciones','CatalogoAdaptation','Catalogo adaptaciones',NULL,'Catalogos','Adaptaciones','2020-12-15 16:13:36','2020-12-15 16:13:36');
INSERT INTO public.permissions (nombre,accion,clase,descripcion,clase_id,menu,opcion,created_at,updated_at) VALUES
	 ('Catalogo talleres','catalogo_talleres','CatalogWorkshop','Catalogo talleres',NULL,'Catalogos','Talleres','2020-12-15 16:13:36','2020-12-15 16:13:36'),
	 ('Catalogo parámetro presupuesto combustible','catalogo_presupueto_combustible','FuelBudget','Catalogo parámetro presupuesto combustible',NULL,'Catalogos','Parámetro presupuesto combustible','2020-12-15 16:13:36','2020-12-15 16:13:36'),
	 ('Catalogo tipo siniestro','catalogo_tipo_siniestro','TypeSinister','Catalogo tipo siniestro',NULL,'Catalogos','Tipo siniestro','2020-12-15 16:13:36','2020-12-15 16:13:36'),
	 ('Catalogo afeccion contable','catalogo_afeccion_contable','AccountingImpact','Catalogo afeccion contable',NULL,'Catalogos','Afeccion contable','2020-12-15 16:13:36','2020-12-15 16:13:36'),
	 ('Catalogo areas','catalogo_areas','CatalogArea','Catalogo areas',NULL,'Catalogos','Area','2020-12-15 16:13:36','2020-12-15 16:13:36'),
	 ('Catalogo responsables','catalogo_responsables','Responsable','Catalogo responsable',NULL,'Catalogos','Responsable','2020-12-15 16:13:36','2020-12-15 16:13:36'),
	 ('Catalogo motivos','catalogo_motivos','Reason','Catalogo motivos',NULL,'Catalogos','Motivos','2020-12-15 16:13:36','2020-12-15 16:13:36'),
	 ('Catalogo clientes','catalogo_clientes','Customer','Catalogo clientes',NULL,'Catalogos','Clientes','2020-12-15 16:13:36','2020-12-15 16:13:36'),
	 ('Catalogo direcciones entrega','catalogo_direcciones_entrega','DeliveryAddress','Catalogo direcciones entrega',NULL,'Catalogos','Direcciones entrega','2020-12-15 16:13:36','2020-12-15 16:13:36'),
	 ('Catalogo consideraciones físicas de vehículo','catalogo_consideraciones_fisicas','CatalogConsideration','Catalogo consideraciones físicas de vehículo',NULL,'Catalogos','Consideraciones físicas de vehículo','2020-12-15 16:13:36','2020-12-15 16:13:36');
INSERT INTO public.permissions (nombre,accion,clase,descripcion,clase_id,menu,opcion,created_at,updated_at) VALUES
	 ('Catalogo revisiones mecánicas de vehículo','catalogo_revision_mecanica','MechanicalReview','Catalogo revisiones mecánicas de vehículo',NULL,'Catalogos','Revisiones mecánicas de vehículo','2020-12-15 16:13:36','2020-12-15 16:13:36'),
	 ('Catalogo empresas facturables','catalogo_empresas_facturables','BilledCompany','Catalogo empresas facturables',NULL,'Catalogos','Empresas facturables



','2020-12-15 16:13:36','2020-12-15 16:13:36'),
	 ('Catalogo cobertura de pólizas','catalogo_cobertura_polizas','PolicyCoverage','Catalogo cobertura de pólizas',NULL,'Catalogos','Cobertura de pólizas


','2020-12-15 16:13:36','2020-12-15 16:13:36'),
	 ('Catalogo estatus de vehículos','catalogo_estatus_vehiculos','VehicleStatus','Catalogo estatus de vehículos',NULL,'Catalogos','Estatus de vehículos



','2020-12-15 16:13:36','2020-12-15 16:13:36'),
	 ('Catalogo tipos de vehículo','catalogo_tipo_vehiculos','VehicleType','Catalogo tipos de vehículo',NULL,'Catalogos','Tipos de vehículo


','2020-12-15 16:13:36','2020-12-15 16:13:36'),
	 ('Catalogo asignación de vehículos por usuario','catalogo_asiganacion_vehiculos','UserVehicle','Catalogo asignación de vehículos por usuario',NULL,'Catalogos','Asignación de vehículos por usuario','2020-12-15 16:13:36','2020-12-15 16:13:36'),
	 ('Catalogo objetivos de rendimiento','catalogo_objetivo_rendimiento','PerformTarget','Catalogo objetivos de rendimiento',NULL,'Catalogos','Objetivos de rendimiento','2020-12-15 16:13:36','2020-12-15 16:13:36'),
	 ('Catalogo indicadores entrega de vehículo','catalogo_inidicadores_entrega','VehicleIndicator','Catalogo indicadores entrega de vehículo',NULL,'Catalogos','Indicadores entrega de vehículo','2020-12-15 16:13:36','2020-12-15 16:13:36'),
	 ('Tabla de competencias','catalogo_tabla_competencias','CompetitionTable','Tabla de competencias',NULL,'Catalogos','Tabla de competencias','2020-12-15 16:13:36','2020-12-15 16:13:36'),
	 ('Catalogo lista de precios afinaciones por CEDIS','catalogo_lista_precios','TuningPrice','Catalogo lista de precios afinaciones por CEDIS',NULL,'Catalogos','Lista de precios afinaciones por CEDIS','2020-12-15 16:13:36','2020-12-15 16:13:36');
INSERT INTO public.permissions (nombre,accion,clase,descripcion,clase_id,menu,opcion,created_at,updated_at) VALUES
	 ('Catalogo objetivo gasto por tipo de vehículo','catalogo_objetivo_gastos','ExpenseVehicleType','Catalogo objetivo gasto por tipo de vehículo',NULL,'Catalogos','Objetivo gasto por tipo de vehículo','2020-12-15 16:13:36','2020-12-15 16:13:36');

	 INSERT INTO public.permissions (nombre,accion,clase,descripcion,clase_id,menu,opcion,created_at,updated_at) VALUES

	('Ver Consumo Por Vehiculos','ver_consumo_por_vehiculos','VehicleConsumption','Ver Consumo Por Vehiculos',NULL,'Movíl','Combustibles','2020-12-15 16:13:36','2020-12-15 16:13:36'),
	
	('Autorizar Consumo de Combustible','autorizar_consumo','Consumption','Autorizar Consumo de Combustible',NULL,'Movíl','Combustibles','2020-12-15 16:13:36','2020-12-15 16:13:36')

	;
	 EOL
	 sql.split(';').each do |s|
	   connection.execute(s.strip) unless s.strip.empty?
	 end


	#  , ('Ver Presupuestos Venta','ver_presupuesto_venta','BudgetConcept','Ver Presupuestos Venta',NULL,'Movíl','Presupuestos','2020-12-15 16:13:36','2020-12-15 16:13:36'),
	#  ('Ver Presupuestos Administración','ver_presupuestos_administracion','BudgetAdministration','Ver Presupuestos Administración',NULL,'Movíl','Presupuestos','2020-12-15 16:13:36','2020-12-15 16:13:36'),
	#  ('Ver Presupuestos Distribución','ver_presupuestos_distribucion','BudgetDistribution','Ver Presupuestos Distribución',NULL,'Movíl','Presupuestos','2020-12-15 16:13:36','2020-12-15 16:13:36'),

	#  ('Autorizar Presupuesto Venta','autorizar_presupuesto_venta','BudgetConcept','Autorizar Presupuesto Venta',NULL,'Movíl','Presupuesto','2020-12-15 16:13:36','2020-12-15 16:13:36'),
	#  ('Autorizar Presupuesto Administracion','autorizar_presupuesto_administracion','BudgetAdministration','Autorizar Presupuesto Administración',NULL,'Movíl','Presupuesto','2020-12-15 16:13:36','2020-12-15 16:13:36'),
	#  ('Autorizar Presupuesto Gerencia','autorizar_presupuesto_distribucion','BudgetDistribution','Autorizar Presupuesto Gerencia',NULL,'Movíl','Presupuesto','2020-12-15 16:13:36','2020-12-15 16:13:36'),

	#  ('Solicitud de Compra Ventas','compras_ventas','PurchaseOrder','Solicitud de Compra Ventas',NULL,'Movíl','Presupuestos','2020-12-15 16:13:36','2020-12-15 16:13:36'),
	#  ('Solicitud de Compras Administración','compras_administracion','PurchaseOrder','Solicitud de Compras Administración',NULL,'Movíl','Presupuestos','2020-12-15 16:13:36','2020-12-15 16:13:36'),
	#  ('Solicitud de compras Gerencia','compras_gerencia','PurchaseOrder','Solicitud de compras Gerencia',NULL,'Movíl','Presupuestos','2020-12-15 16:13:36','2020-12-15 16:13:36')