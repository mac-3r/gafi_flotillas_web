connection = ActiveRecord::Base.connection()
sql = <<-EOL
INSERT INTO public.permissions (nombre,accion,clase,descripcion,clase_id,menu,opcion,created_at,updated_at) VALUES
('Autorizar presupuestos','autorizar_presupuesto','BudgetItem','Autorizar presupuestos',NULL,'Movil','Presupuestos','2020-10-05 15:24:45','2020-10-05 15:24:45'),
('Ver presupuestos autorizados','ver_presupuestos_autorizados','BudgetItem','Ver presupuestos autorizados',NULL,'Movil','Presupuestos','2020-10-05 15:24:45','2020-10-05 15:24:45'),
('Solicitar orden de compra','solicitar_orden_compra','PurchaseOrder','Solicitar orden de compra',NULL,'Movil','Compras','2020-10-05 15:24:45','2020-10-05 15:24:45'),
('Ver compras','ver_compras','PurchaseOrder','Ver compras',NULL,'Movil','Compras','2020-10-05 15:24:45','2020-10-05 15:24:45'),
('Autorizar compras','autorizar_compra','PurchaseOrder','Autorizar compras',NULL,'Movil','Compras','2020-10-05 15:24:45','2020-10-05 15:24:45'),
('Ver adaptaciones','veradaptaciones','VehicleAdaptation','Ver adaptaciones',NULL,'Adaptaciones','Adaptaciones','2020-10-05 15:24:45','2020-10-05 15:24:45'),
('Autorizar adaptacion','autorizar_adaptaciones','VehicleAdaptation','Ver adaptaciones',NULL,'Movil','Adaptaciones','2020-10-05 15:24:45','2020-10-05 15:24:45'),

('Ver citas Mantenimiento','citas_mantenimiento','ServiceOrder','Ver tickets vehículos',NULL,'Movil','Ticket vehículos','2020-10-05 15:24:45','2020-10-05 15:24:45'),
('Autorizar citas','autorizar_citas','ServiceOrder','Ver citas',NULL,'Movil','Citas','2020-10-05 15:24:45','2020-10-05 15:24:45'),
('Ver tickets mantenimiento','tickets_matenimiento','MaintenanceTicket','Ver tickets mantenimiento',NULL,'Movil','Mantenimiento','2020-10-05 15:24:45','2020-10-05 15:24:45'),
('Autorizar ticket mantenimiento','autorizar_tickets_mantenimiento','MaintenanceTicket','Autorizar ticket mantenimiento',NULL,'Movil','Mantenimiento','2020-10-05 15:24:45','2020-10-05 15:24:45'),

('Ver  ticket solicitud','ver_ticket_solicitud','TicketTireBattery','Ver  ticket solicitud  ticket',NULL,'Movil','Ticket solicitud','2020-10-05 15:24:45','2020-10-05 15:24:45'),
('Autorizar  ticket','autorizar_tickets','TicketTireBattery','Autorizar  ticket',NULL,'Movil','Ticket solicitud','2020-10-05 15:24:45','2020-10-05 15:24:45'),
('Reagendar ordenes','cambiar_fecha_mmto','ServiceOrder','Reagendar ordenes',NULL,'Mantenimiento','Reagendar ordenes','2020-12-15 16:13:36.000','2020-12-15 16:13:36.000'),
('Ver cotizaciones','cotizacion_detalle','ServiceOrder','Ver cotizaciones',NULL,'Mantenimiento','Ver cotizaciones','2020-12-15 16:13:36.000','2020-12-15 16:13:36.000'),
('Agregar cotizaciones','creacion_cotizaciones','ServiceOrder','Agregar cotizaciones',NULL,'Mantenimiento','Agregar cotizaciones','2020-12-15 16:13:36.000','2020-12-15 16:13:36.000')
;
EOL
sql.split(';').each do |s|                                        
  connection.execute(s.strip) unless s.strip.empty?
end