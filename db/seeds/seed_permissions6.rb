connection = ActiveRecord::Base.connection()
sql = <<-EOL
INSERT INTO permissions (nombre,accion,clase,descripcion,clase_id,menu,opcion,created_at,updated_at) VALUES
	 ('Indicador respuestas por taller','indicador_respuestas','MaintenanceControl','Indicador respuestas por taller',NULL,'Mantenimiento','Indicador respuestas por taller','2020-12-15 16:13:36.000','2020-12-15 16:13:36.000'),
	 ('Indicador siniestros por CEDIS','indicador_cedis','InsuranceReportTicket','Indicador siniestros por CEDIS',NULL,'Siniestralidad','Indicador siniestros por CEDIS','2020-12-15 16:13:36.000','2020-12-15 16:13:36.000'),
	 ('Bitácora de vehículos','bitacora_vehiculos','VehicleLog','Bitácora de vehículos',NULL,'Seguridad','Bitácora de vehículos','2020-12-15 16:13:36.000','2020-12-15 16:13:36.000'),
	 ('Bitácora de pólizas','bitacora_polizas','JdeLog','Bitácora de pólizas',NULL,'Seguridad','Bitácora de pólizas','2020-12-15 16:13:36.000','2020-12-15 16:13:36.000'),
	 ('Ver checklist del vehículo','checklist_vehiculos','Vehicle','Ver checklist del vehículo',NULL,'Maestro de vehículos','Ver checklist del vehículo','2020-12-15 16:13:36.000','2020-12-15 16:13:36.000'),
	 ('Editar usuario autorizado','cambio_usuario_combustible','Consumption','Editar usuario autorizado',NULL,'Combustible','Editar usuario autorizado','2020-12-15 16:13:36.000','2020-12-15 16:13:36.000'),
	 ('Bitácora de mantenimiento','index_bitacora','Concept','Bitácora de mantenimiento',NULL,'Catalogos','Bitácora de mantenimiento','2020-12-15 16:13:36.000','2020-12-15 16:13:36.000'),
	 ('Corte de gastos','cortes_gastos','Deadline','Corte de gastos',NULL,'Seguridad','Corte de gastos','2020-12-15 16:13:36.000','2020-12-15 16:13:36.000'),
	 ('Finalizar orden de servicio','finalizar_orden_servicio','ServiceOrder','Finalizar orden de servicio',NULL,'Mantenimiento','Finalizar orden de servicio','2020-12-15 16:13:36.000','2020-12-15 16:13:36.000')
	 ;


	
     EOL
sql.split(';').each do |s|                                        
    connection.execute(s.strip) unless s.strip.empty?
end