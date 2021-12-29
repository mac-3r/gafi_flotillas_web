# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
User.create(email: "admin@gafi.com", password: "123456")

connection = ActiveRecord::Base.connection()
sql = "ALTER TABLE permissions DISABLE TRIGGER ALL;"
sql2 = "ALTER TABLE permissions ENABLE TRIGGER ALL;"
ActiveRecord::Base.connection.execute(sql)
ActiveRecord::Base.connection.reset_pk_sequence!("permissions")
ActiveRecord::Base.connection.execute(sql2)
sql = <<-EOL

INSERT INTO permissions (nombre,accion,clase,descripcion,clase_id,menu,opcion,created_at,updated_at) VALUES 
	('Compra de vehiculos','compra_vehiculos','Vehicle','Compra de vehiculos',NULL,'Maestro de vehí­culos','Compra de vehículos','2020-12-15 16:13:36.000','2020-12-15 16:13:36.000')
	,('Editar vehiculos','editar_vehiculos','Vehicle','Editar vehiculos',NULL,'Maestro de vehículos','Editar vehiculos','2020-12-15 16:13:36.000','2020-12-15 16:13:36.000')
	,('Eliminar vehículos','eliminar_vehiculos','Vehicle','Eliminar vehí­culos',NULL,'Maestro de vehí­culos','Eliminar vehículos','2020-12-15 16:13:36.000','2020-12-15 16:13:36.000')
	,('Expediente de vehí­culos','expediente_vehiculo','Vehicle','Expediente de vehí­culos',NULL,'Maestro de vehículos','Expediente de vehículos','2020-12-15 16:13:36.000','2020-12-15 16:13:36.000')
	,('Venta de vehículos','venta_vehiculos','Vehicle','Venta de vehículos',NULL,'Maestro de vehículos','Venta de vehí­culos','2020-12-15 16:13:36.000','2020-12-15 16:13:36.000');
	INSERT INTO permissions (nombre,accion,clase,descripcion,clase_id,menu,opcion,created_at,updated_at) VALUES 
	('Crear presupuestos de compra de vehí­culos de venta','presupuestos_venta','BudgetConcept','Crear presupuestos de compra de vehí­culos de venta',NULL,'Presupuestos','Presupuestos de vehiculos de venta','2020-12-15 16:13:36.000','2020-12-15 16:13:36.000')
	,('Crear presupuestos de compra de vehí­culos de administración','presupuestos_administracion','BudgetAdministration','Crear presupuestos de compra de vehículos de administración',NULL,'Presupuestos','Presupuestos de vehiculos de administración','2020-12-15 16:13:36.000','2020-12-15 16:13:36.000')
	,('Crear presupuestos de compra de vehículos de reparto','presupuestos_reparto','BudgetDistribution','Crear presupuestos de compra de vehí­culos de reparto',NULL,'Presupuestos','Presupuestos de vehiculos de reparto','2020-12-15 16:13:36.000','2020-12-15 16:13:36.000')
	,('Ver tablero presupuestos de compra de vehículos de venta','ver_presupuesto_venta','BudgetConcept','Ver tablero presupuestos de compra de vehí­culos de venta',NULL,'Presupuestos','Presupuestos de vehiculos de venta','2020-12-15 16:13:36.000','2020-12-15 16:13:36.000')
	,('Solicitar autorización presupuestos de compra de vehí­culos de venta','solicitar_autorizacion_presupuesto_venta','BudgetConcept','Solicitar autorización presupuestos de compra de vehí­culos de venta',NULL,'Presupuestos','Presupuestos de vehiculos de venta','2020-12-15 16:13:36.000','2020-12-15 16:13:36.000')
	,('Ver tablero de presupuestos de compra de vehículos de administración','ver_presupuesto_administracion','BudgetAdministration','Ver tablero de presupuestos de compra de vehículos de administración',NULL,'Presupuestos','Ver tablero de presupuestos de compra de vehículos de administración','2020-12-15 16:13:36.000','2020-12-15 16:13:36.000')
	,('Solicitar autorización presupuestos de compra de vehículos de administración','solicitar_autorizacion_presupuesto_administracion','BudgetAdministration','Solicitar autorización presupuestos de compra de vehículos de administración',NULL,'Presupuestos','Solicitar autorización presupuestos de compra de vehí­culos de administración','2020-12-15 16:13:36.000','2020-12-15 16:13:36.000')
	,('Ver tablero presupuestos de compra de vehículos de reparto','ver_presupuesto_reparto','BudgetDistribution','Ver tablero presupuestos de compra de vehículos de reparto',NULL,'Presupuestos','Ver tablero presupuestos de compra de vehículos de reparto','2020-12-15 16:13:36.000','2020-12-15 16:13:36.000')
	,('Solicitar autorización presupuestos de compra de vehí­culos de reparto','solicitar_autorizacion_presupuesto_reparto','BudgetDistribution','Solicitar autorización presupuestos de compra de vehículos de reparto',NULL,'Presupuestos','Solicitar autorización presupuestos de compra de vehículos de reparto','2020-12-15 16:13:36.000','2020-12-15 16:13:36.000');
	INSERT INTO permissions (nombre,accion,clase,descripcion,clase_id,menu,opcion,created_at,updated_at) VALUES 
	('Ver ordenes de compra','orden_compra','PurchaseOrder','Ver ordenes de compra',NULL,'Ordenes de compra','Ver Index de ordenes de compra','2020-12-15 16:13:36.000','2020-12-15 16:13:36.000')
	,('Crear ordenes de compra','crear_orden','PurchaseOrder','Crear ordenes de compra',NULL,'Ordenes de compra','Crear ordenes de compra','2020-12-15 16:13:36.000','2020-12-15 16:13:36.000')
	,('Adjuntar documentos','adjuntar_documento','PurchaseOrder','Adjuntar documentos',NULL,'Ordenes de compra','Adjuntar documentos','2020-12-15 16:13:36.000','2020-12-15 16:13:36.000')
	,('Generar PDF','generar_pdf_orden','PurchaseOrder','Generar PDF',NULL,'Ordenes de compra','Generar PDF','2020-12-15 16:13:36.000','2020-12-15 16:13:36.000');
	INSERT INTO permissions (nombre,accion,clase,descripcion,clase_id,menu,opcion,created_at,updated_at) VALUES 
	('Crear usuarios','crear_usuarios','User','Crear usuarios',NULL,'Seguridad','Usuarios','2020-12-15 16:13:36.000','2020-12-15 16:13:36.000')
	,('Crear roles','crear_roles','CatalogRole','Crear usuarios',NULL,'Seguridad','Roles','2020-12-15 16:13:36.000','2020-12-15 16:13:36.000')
	,('Asignar roles a usuarios','roles_usuarios','CatalogRolesUser','Asignar roles a usuarios',NULL,'Seguridad','Roles de usuarios','2020-12-15 16:13:36.000','2020-12-15 16:13:36.000')
	,('Asignar CEDIS a usuarios','asignacion_cedis_usuarios','CatalogBranchesUser','Asignar CEDIS a usuarios',NULL,'Seguridad','Asignar CEDIS a usuarios','2020-12-15 16:13:36.000','2020-12-15 16:13:36.000');
	INSERT INTO permissions (nombre,accion,clase,descripcion,clase_id,menu,opcion,created_at,updated_at) VALUES 
	('Reporte anual acumulado de responsivas','reporte_acumulado_responsivas','Vehicle','Reporte anual acumulado de responsivas',NULL,'Reportes','Reporte de responsivas','2020-12-15 16:13:36.000','2020-12-15 16:13:36.000');
	INSERT INTO permissions (nombre,accion,clase,descripcion,clase_id,menu,opcion,created_at,updated_at) VALUES 
	('Ver tablero siniestralidad','ver_tablero_siniestralidad','InsuranceReportTicket','Ver tablero siniestralidad',NULL,'Siniestralidad','Index siniestralidad','2020-12-15 16:13:36.000','2020-12-15 16:13:36.000')
	,('Crear tickets reportados por aseguradora','crear_registros_siniestralidad','InsuranceReportTicket','Crear tickets reportados por aseguradora',NULL,'Siniestralidad','Registrar siniestralidad','2020-12-15 16:13:36.000','2020-12-15 16:13:36.000')
	,('Editar tickets reportados por aseguradora','editar_registros_siniestralidad','InsuranceReportTicket','Editar tickets reportados por aseguradora',NULL,'Siniestralidad','Editar siniestralidad','2020-12-15 16:13:36.000','2020-12-15 16:13:36.000')
	,('Eliminar tickets reportados por aseguradora','eliminar_registros_siniestralidad','InsuranceReportTicket','Eliminar tickets reportados por aseguradora',NULL,'Siniestralidad','Eliminar siniestralidad','2020-12-15 16:13:36.000','2020-12-15 16:13:36.000')
	,('Realizar corte','realizar_corte','InsuranceReportTicket','Realizar corte',NULL,'Siniestralidad','Corte siniestralidad','2020-12-15 16:13:36.000','2020-12-15 16:13:36.000')
	,('Generar ticket','generar_ticket_siniestrabilidad','InsuranceReportTicket','Generar ticket',NULL,'Siniestralidad','Generar ticket siniestralidad','2020-12-15 16:13:36.000','2020-12-15 16:13:36.000')
	,('Reporte de incidencias por responsable de siniestro','reporte_siniestralidad','responsible_incident_report','Reporte de incidencias por responsable de siniestro',NULL,'Siniestralidad','Reporte de incidencias por responsable de siniestro','2020-12-15 16:13:36.000','2020-12-15 16:13:36.000')
	,('Informe de siniestralidad','informe_siniestralidad','claim_report','Informe siniestralidad ',NULL,'Siniestralidad','Informe','2020-12-15 16:13:36.000','2020-12-15 16:13:36.000')
	,('Indicador monto flotilla siniestrada','indicador_monto_siniestrada','damaged_vehicle_ammount_indicator','Indicador monto flotilla siniestrada',NULL,'Siniestralidad','Indicador monto flotilla siniestrada','2020-12-15 16:13:36.000','2020-12-15 16:13:36.000')
	,('Indicador flotilla siniestrada','indicador_flotillas_siniestrada','damaged_vehicle_indicator','Indicador flotilla siniestrada',NULL,'Siniestralidad','Indicador flotilla siniestrada','2020-12-15 16:13:36.000','2020-12-15 16:13:36.000');
	INSERT INTO permissions (nombre,accion,clase,descripcion,clase_id,menu,opcion,created_at,updated_at) VALUES 
	('Indicador porcentaje siniestralidad','indicador_porcentaje_siniestrada','damaged_percentage_indicator','Indicador porcentaje siniestralidad',NULL,'Siniestralidad','Indicador porcentaje siniestralidad','2020-12-15 16:13:36.000','2020-12-15 16:13:36.000')
	INSERT INTO permissions (nombre,accion,clase,descripcion,clase_id,menu,opcion,created_at,updated_at) VALUES 
('Crear bitacora de mantemiento','bitacora_mantenimiento','MaintenanceLog','Bitacora de mantemiento',NULL,'Mantenimiento','Bitacora de mantemiento','2020-12-15 16:13:36.000','2020-12-15 16:13:36.000')
,('Seguimiento de captura de kilometraje','seguimiento_kilometraje','MileageIndicator','Seguimiento de captura de kilometraje',NULL,'Mantenimiento','Seguimiento de captura de kilometraje','2020-12-15 16:13:36.000','2020-12-15 16:13:36.000')
,('Ver Control de mantemiento','ver_control_mantenimiento','MaintenanceControl','Ver Control de mantemiento',NULL,'Mantenimiento','Ver Control de mantemiento','2020-12-15 16:13:36.000','2020-12-15 16:13:36.000')
,('Crear control de mantemiento','control_mantenimiento','MaintenanceControl','Control de mantenimiento',NULL,'Mantenimiento','Control de mantenimiento','2020-12-15 16:13:36.000','2020-12-15 16:13:36.000')
,('Ver tablero bitacora de mantemiento','ver_bitacora_mantenimiento','MaintenanceLog','Ver tablero bitacora de mantemiento',NULL,'Mantenimiento','Bitacora de mantemiento','2020-12-15 16:13:36.000','2020-12-15 16:13:36.000')
,('Ver citas','ver_citas','MaintenanceAppointment','Ver citas',NULL,'Mantenimiento','Citas','2020-12-15 16:13:36.000','2020-12-15 16:13:36.000')
,('Crear citas','crear_citas','MaintenanceAppointment','Crear citas',NULL,'Mantenimiento','Citas','2020-12-15 16:13:36.000','2020-12-15 16:13:36.000')
,('Editar citas','editar_citas','MaintenanceAppointment','Editar citas',NULL,'Mantenimiento','Citas','2020-12-15 16:13:36.000','2020-12-15 16:13:36.000')
,('Asignación de taller y confirmación de citas','asignacion_taller','ServiceOrder','Asignación de taller y confirmación de citas',NULL,'Mantenimiento','Citas','2020-12-15 16:13:36.000','2020-12-15 16:13:36.000')
,('Ver ordenes de servicio','orden_servicio','ServiceOrder','Ordenes de servicio',NULL,'Mantenimiento','Ordenes de servicio','2020-12-15 16:13:36.000','2020-12-15 16:13:36.000');
INSERT INTO permissions (nombre,accion,clase,descripcion,clase_id,menu,opcion,created_at,updated_at) VALUES 
('Agregar descripcion a una orden de servicio','agregar_descripcion','ServiceOrder','Ordenes de servicio',NULL,'Mantenimiento','Ordenes de servicio','2020-12-15 16:13:36.000','2020-12-15 16:13:36.000')
,('Autorizar orden de servicio','autorizar_orden_servicio','ServiceOrder','Ordenes de servicio',NULL,'Mantenimiento','Ordenes de servicio','2020-12-15 16:13:36.000','2020-12-15 16:13:36.000')
,('Registrar salida del vehículo','registrar_salida','ServiceOrder','Ordenes de servicio',NULL,'Mantenimiento','Ordenes de servicio','2020-12-15 16:13:36.000','2020-12-15 16:13:36.000')
,('Adjuntar/Descargar facturas y documentos en ordenes de servicio','adjuntar_documentos_orden','ServiceOrder','Ordenes de servicio',NULL,'Mantenimiento','Ordenes de servicio','2020-12-15 16:13:36.000','2020-12-15 16:13:36.000')
,('Ver programa de mantenimiento','programa_mmto','MaintenanceProgram','Programa de mantenimiento',NULL,'Mantenimiento','Programa de mantenimiento','2020-12-15 16:13:36.000','2020-12-15 16:13:36.000')
,('Indicador horas taller','indicador_horas','MaintenanceControl','Indicador horas taller',NULL,'Mantenimiento','Indicador horas taller','2020-12-15 16:13:36.000','2020-12-15 16:13:36.000')
,('Indicador costo mantenimiento por km por vehículo','indicador_costo','ServiceOrder','Indicador costo mantenimiento por km por vehículo',NULL,'Mantenimiento','Indicador costo mantenimiento por km por vehículo','2020-12-15 16:13:36.000','2020-12-15 16:13:36.000')
,('Reporte presupuesto mantenimiento','reporte_mantenimiento','MaintenanceControl','Reporte presupuesto mantenimiento',NULL,'Mantenimiento','Reporte presupuesto mantenimiento','2020-12-15 16:13:36.000','2020-12-15 16:13:36.000');
INSERT INTO permissions (nombre,accion,clase,descripcion,clase_id,menu,opcion,created_at,updated_at) VALUES 
('Ver tablero certificacion de talleres','ver_cetificacion_talleres','WorkshopCertification','Ver tablero certificacion de talleres',NULL,'Certificación de talleres','Ver tablero certificacion de talleres','2020-12-15 16:13:36.000','2020-12-15 16:13:36.000')
,('Editar certificación de talleres','editar_cerficacion_talleres','WorkshopCertification','Editar certificación de talleres',NULL,'Certificación de talleres','Editar certificación de talleres','2020-12-15 16:13:36.000','2020-12-15 16:13:36.000')
,('Adjuntar documentación de talleres','adjuntar_documentos_taller','WorkshopCertification','Adjuntar documentación de talleres',NULL,'Certificación de talleres','Adjuntar documentación de talleres','2020-12-15 16:13:36.000','2020-12-15 16:13:36.000')
,('Imprimir formato de alta','imp_formato_alta','WorkshopCertification','Imprimir formato de alta',NULL,'Certificación de talleres','Imprimir formato de alta','2020-12-15 16:13:36.000','2020-12-15 16:13:36.000')
;
EOL
sql.split(';').each do |s|
connection.execute(s.strip) unless s.strip.empty?
end