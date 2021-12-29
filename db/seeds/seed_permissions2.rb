connection = ActiveRecord::Base.connection()
sql = <<-EOL
INSERT INTO public.permissions (nombre,accion,clase,descripcion,clase_id,menu,opcion,created_at,updated_at) VALUES
('Asignar vehiculo','ver_pendientes_entrega','Vehicle','Asignar vehiculo',NULL,'Movíl','Vehículos','2020-10-05 15:24:45','2020-10-05 15:24:45'),
('Pendientes Recibir','ver_pendientes_recibir','Vehicle','Pendientes Recibir',NULL,'Movíl','Vehículos','2020-10-05 15:24:45','2020-10-05 15:24:45'),
('Vehiculos entreados','ver_vehiculos_entregados','Vehicle','Vehiculos entreados',NULL,'Movíl','Vehículos','2020-10-05 15:24:45','2020-10-05 15:24:45'),
('Vehiculos en transito','ver_en_transito','Vehicle','Vehiculos en transito',NULL,'Movíl','Vehículos','2020-10-05 15:24:45','2020-10-05 15:24:45'),
('Vehiculo para venta','ver_vehiculo_para_venta','Vehicle','Vehiculo para venta',NULL,'Movíl','Vehículos','2020-10-05 15:24:45','2020-10-05 15:24:45'),
('Autorizar vehículo venta','autorizar_vehiculo_para_venta','Vehicle','Autorizar vehículo venta',NULL,'Movíl','Vehículos','2020-10-05 15:24:45','2020-10-05 15:24:45'),

('Ver solicitud de talleres','ver_solicitud','WorkshopCertification','Ver solicitud de talleres',NULL,'Movíl','Talleres','2020-10-05 15:24:45','2020-10-05 15:24:45'),
('Crear certificacion de taller','crear_certificacion','WorkshopCertification','Crear certificacion de taller',NULL,'Movíl','Talleres','2020-10-05 15:24:45','2020-10-05 15:24:45'),
('Autorizar certificación taller','autorizar_certificacion_de_taller','WorkshopCertification','Autorizar certificación taller',NULL,'Movíl','Talleres','2020-10-05 15:24:45','2020-10-05 15:24:45'),


('Ver talleres','ver_talleres','CatalogWorkshop','Ver talleres',NULL,'Movíl','Talleres','2020-10-05 15:24:45','2020-10-05 15:24:45'),
('Ver taller','ver_taller','CatalogWorkshop','Ver taller',NULL,'Movíl','Talleres','2020-10-05 15:24:45','2020-10-05 15:24:45'),
('Crear taller','crear_taller','CatalogWorkshop','Crear taller',NULL,'Movíl','Talleres','2020-10-05 15:24:45','2020-10-05 15:24:45'),
('Editar taller','editar_taller','CatalogWorkshop','Editar taller',NULL,'Movíl','Talleres','2020-10-05 15:24:45','2020-10-05 15:24:45')

;
EOL
sql.split(';').each do |s|                                        
  connection.execute(s.strip) unless s.strip.empty?
end
# ('Ver documentacion de taller','ver_documentacion','WorkshopCertification','Ver documentacion de taller',NULL,'Movíl','Talleres','2020-10-05 15:24:45','2020-10-05 15:24:45');