connection = ActiveRecord::Base.connection()
sql = <<-EOL
INSERT INTO permissions (nombre,accion,clase,descripcion,clase_id,menu,opcion,created_at,updated_at) VALUES 
('Seguimiento de captura de kilometraje','seguimiento_kilometraje','MileageIndicator','Seguimiento de captura de kilometraje',NULL,'Mantenimiento','Seguimiento de captura de kilometraje','2020-12-15 16:13:36.000','2020-12-15 16:13:36.000')
,('Ver Control de mantemiento','ver_control_mantenimiento','MaintenanceControl','Ver Control de mantemiento',NULL,'Mantenimiento','Ver Control de mantemiento','2020-12-15 16:13:36.000','2020-12-15 16:13:36.000')
,('Ver tablero bitacora de mantemiento','ver_bitacora_mantenimiento','MaintenanceLog','Ver tablero bitacora de mantemiento',NULL,'Mantenimiento','Bitacora de mantemiento','2020-12-15 16:13:36.000','2020-12-15 16:13:36.000')
,('Ver citas','ver_citas','MaintenanceAppointment','Ver citas',NULL,'Mantenimiento','Citas','2020-12-15 16:13:36.000','2020-12-15 16:13:36.000')
,('Asignación de taller y confirmación de citas','asignacion_taller','ServiceOrder','Asignación de taller y confirmación de citas',NULL,'Mantenimiento','Citas','2020-12-15 16:13:36.000','2020-12-15 16:13:36.000')
,('Ver ordenes de servicio','orden_servicio','ServiceOrder','Ordenes de servicio',NULL,'Mantenimiento','Ordenes de servicio','2020-12-15 16:13:36.000','2020-12-15 16:13:36.000')
,('Agregar descripcion a una orden de servicio','agregar_descripcion','ServiceOrder','Ordenes de servicio',NULL,'Mantenimiento','Ordenes de servicio','2020-12-15 16:13:36.000','2020-12-15 16:13:36.000')
,('Autorizar orden de servicio','autorizar_orden_servicio','ServiceOrder','Ordenes de servicio',NULL,'Mantenimiento','Ordenes de servicio','2020-12-15 16:13:36.000','2020-12-15 16:13:36.000')
,('Adjuntar/Descargar facturas y documentos en ordenes de servicio','adjuntar_documentos_orden','ServiceOrder','Ordenes de servicio',NULL,'Mantenimiento','Ordenes de servicio','2020-12-15 16:13:36.000','2020-12-15 16:13:36.000')
,('Ver programa de mantenimiento','programa_mmto','MaintenanceProgram','Programa de mantenimiento',NULL,'Mantenimiento','Programa de mantenimiento','2020-12-15 16:13:36.000','2020-12-15 16:13:36.000')
;
INSERT INTO permissions (nombre,accion,clase,descripcion,clase_id,menu,opcion,created_at,updated_at) VALUES 
('Indicador horas taller','indicador_taller_hrs','MaintenanceControl','Indicador horas taller',NULL,'Mantenimiento','Indicador horas taller','2020-12-15 16:13:36.000','2020-12-15 16:13:36.000')
,('Indicador costo mantenimiento por km por vehículo
','indicador_costo_mmto','ServiceOrder','Indicador costo mantenimiento por km por vehículo',NULL,'Mantenimiento','Indicador costo mantenimiento por km por vehículo','2020-12-15 16:13:36.000','2020-12-15 16:13:36.000')
,('Reporte presupuesto mantenimiento','reporte_pres_mantenimiento','MaintenanceControl','Reporte presupuesto mantenimiento',NULL,'Mantenimiento','Reporte presupuesto mantenimiento','2020-12-15 16:13:36.000','2020-12-15 16:13:36.000')
,('Registrar salida del vehículo','registrar_salida_ordenes','ServiceOrder','Ordenes de servicio',NULL,'Mantenimiento','Ordenes de servicio','2020-12-15 16:13:36.000','2020-12-15 16:13:36.000')
,('Ver servicios adicionales','ver_servicios_adicionales','ServiceOrder','Ver servicios adicionales',NULL,'Mantenimiento','Ordenes de servicio','2020-10-05 15:24:45.000','2020-10-05 15:24:45.000')
,('Solicitar servicios adicionales','solicitar_servicios_adicionales','ServiceOrder','Solicitar servicios adicionales',NULL,'Mantenimiento','Ordenes de servicio','2020-10-05 15:24:45.000','2020-10-05 15:24:45.000')
,('Autorizar/Rechazar servicios adicionales','autorizacion_servicios_adicionales','ServiceOrder','Autorizar/Rechazar servicios adicionales',NULL,'Mantenimiento','Ordenes de servicio','2020-10-05 15:24:45.000','2020-10-05 15:24:45.000')
,('Editar control de mantenimiento','control_mantenimiento','MaintenanceControl','Editar control de mantenimiento',NULL,'Mantenimiento','Control de mantenimiento','2020-10-05 15:24:45.000','2020-10-05 15:24:45.000')
;
INSERT INTO permissions (nombre,accion,clase,descripcion,clase_id,menu,opcion,created_at,updated_at) VALUES 
('Ver tickets','ver_tickets_mmto','MaintenanceTicket','Ver tickets',NULL,'Tickets','Tickets mantenimiento','2020-10-05 15:24:45.000','2020-10-05 15:24:45.000')
,('Editar descripción','editar_ticket_mmto','MaintenanceTicket','Editar descripción',NULL,'Tickets','Tickets mantenimiento','2020-10-05 15:24:45.000','2020-10-05 15:24:45.000')
,('Autorizar/Rechazar tickets','autorizacion_tickets_mmto','MaintenanceTicket','Autorizar/Rechazar tickets',NULL,'Tickets','Tickets mantenimiento','2020-10-05 15:24:45.000','2020-10-05 15:24:45.000')
;
INSERT INTO permissions (nombre,accion,clase,descripcion,clase_id,menu,opcion,created_at,updated_at) VALUES 
('Catalogo seccion de areas','catalogo_secciones_areas','Section','Catalogo seccion de areas',NULL,'Catalogos','Secciones de areas','2020-10-05 15:24:45.000','2020-10-05 15:24:45.000')
,('Agregar adaptaciones','adaptaciones_vehiculos','Vehicle','Agregar adaptaciones',NULL,'Maestro de vehículos','Agregar adaptaciones','2020-12-15 16:13:36.000','2020-12-15 16:13:36.000')
,('Solicitar adaptaciones','sol_adaptacion','VehicleAdaptation','Solicitar adaptaciones',NULL,'Maestro de vehículos','Solicitar adaptaciones','2020-12-15 16:13:36.000','2020-12-15 16:13:36.000')
,('Adjuntar documentos de adaptaciones','adjuntar_documento_adaptacion','VehicleAdaptation','Adjuntar documentos de adaptaciones',NULL,'Maestro de vehículos','Adjuntar documentos de adaptaciones','2020-12-15 16:13:36.000','2020-12-15 16:13:36.000')
;
INSERT INTO permissions (nombre,accion,clase,descripcion,clase_id,menu,opcion,created_at,updated_at) VALUES 
('Eliminar presupuestos de compra de vehículos de administración','eliminar_pres_admin','BudgetAdministration','Eliminar presupuestos de compra de vehículos de administración',NULL,'Presupuestos','Presupuestos de vehiculos de administración','2020-12-15 16:13:36.000','2020-12-15 16:13:36.000')
,('Eliminar presupuestos de compra de vehículos de venta','eliminar_pres_venta','BudgetConcept','Eliminar presupuestos de compra de vehículos de venta',NULL,'Presupuestos','Presupuestos de vehiculos de venta','2020-12-15 16:13:36.000','2020-12-15 16:13:36.000')
,('Eliminar presupuestos de compra de vehículos de reparto','eliminar_pres_dis','BudgetDistribution','Eliminar presupuestos de compra de vehículos de reparto',NULL,'Presupuestos','Presupuestos de vehiculos de reparto','2020-12-15 16:13:36.000','2020-12-15 16:13:36.000')
,('Eliminar cargas de combustibe','borrrar_cargas_combustible','Consumption','Eliminar cargas de combustibe',NULL,'Combustible','Consumo por vehículos','2020-10-05 15:24:45.000','2020-10-05 15:24:45.000')
;
INSERT INTO permissions (nombre,accion,clase,descripcion,clase_id,menu,opcion,created_at,updated_at) VALUES 
('Ver solicitudes de compra ','ver_tablero_ticket_compra','TicketTireBattery','Ver solicitudes de compra ',NULL,'Maestro de vehículos','Ver solicitudes de compra ','2020-12-15 16:13:36.000','2020-12-15 16:13:36.000')
,('Autorizar/Rechazar solicitudes de compra','autorizacion_ticket_compra','TicketTireBattery','Autorizar/Rechazar solicitudes de compra',NULL,'Maestro de vehículos','Autorizar/Rechazar solicitudes de compra','2020-12-15 16:13:36.000','2020-12-15 16:13:36.000')
,('Crear orden compra para llantas/baterías','orden_ticket','TicketTireBattery','Crear orden compra para llantas/baterías',NULL,'Maestro de vehículos','Crear orden compra para llantas/baterías','2020-12-15 16:13:36.000','2020-12-15 16:13:36.000')
,('Catalogo llantas y baterias','catalogo_llantas_baterias','CatalogTiresBattery','Catalogo llantas y baterias',NULL,'Catalogos','Llantas y baterias','2020-12-15 16:13:36.000','2020-12-15 16:13:36.000')
;
EOL
sql.split(';').each do |s|                                        
  connection.execute(s.strip) unless s.strip.empty?
end
# ('Ver documentacion de taller','ver_documentacion','WorkshopCertification','Ver documentacion de taller',NULL,'Movíl','Talleres','2020-10-05 15:24:45','2020-10-05 15:24:45');