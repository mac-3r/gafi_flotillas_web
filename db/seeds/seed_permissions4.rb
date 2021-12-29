connection = ActiveRecord::Base.connection()
sql = <<-EOL
INSERT INTO public.permissions (nombre,accion,clase,descripcion,clase_id,menu,opcion,created_at,updated_at) VALUES
('Ver presupuestos','ver_presupuestos','Budget','Ver presupuestos',NULL,'Maestro de vehículos','Presupuestos','2020-10-05 15:24:45','2020-10-05 15:24:45'),
('Registrar presupuestos','registrar_presupuestos','Budget','Registrar presupuestos',NULL,'Maestro de vehículos','Presupuestos','2020-10-05 15:24:45','2020-10-05 15:24:45'),
('Solicitar autorización de presupuestos','solicitar_autorizacion_presupuestos','Budget','Solicitar autorización de presupuestos',NULL,'Maestro de vehículos','Presupuestos','2020-10-05 15:24:45','2020-10-05 15:24:45');

INSERT INTO permissions (nombre,accion,clase,descripcion,clase_id,menu,opcion,created_at,updated_at) VALUES
	 ('Catalogo de categorias de mantenimiento','catalogo_categorias_mmto','Concept','Catalogo de categorias de mantenimientoCatalogo de categorias de mantenimiento',NULL,'Catalogos','Categorias de mantenimiento','2020-10-05 15:24:45.000','2020-10-05 15:24:45.000'),
	 ('Importar categorias de mantenimiento','importar_categorias_mmto','Concept','Importar categorias de mantenimiento',NULL,'Mantenimiento','Importar categorias de mantenimiento','2020-10-05 15:24:45.000','2020-10-05 15:24:45.000'),
	 ('Catalogo de conceptos de mantenimiento','catalogo_conceptos_mmto','Concept','Catalogo de conceptos de mantenimiento',NULL,'Catalogos','Conceptos de mantenimiento','2020-10-05 15:24:45.000','2020-10-05 15:24:45.000'),
	 ('Importar conceptos de mantenimiento','importar_conceptos_mmto','Concept','Importar conceptos de mantenimiento',NULL,'Mantenimiento','Importar conceptos de mantenimiento','2020-10-05 15:24:45.000','2020-10-05 15:24:45.000'),
	 ('Importar bitacora de mantenimiento','importar_bitacora_mmto','Concept','Importar bitacora de mantenimiento',NULL,'Mantenimiento','Importar bitacora de mantenimiento','2020-10-05 15:24:45.000','2020-10-05 15:24:45.000'),
	 ('Asignar concepto a linea','asignacion_accion_linea','Concept','Asignar concepto a linea',NULL,'Catalogos','Asignar concepto a linea','2020-10-05 15:24:45.000','2020-10-05 15:24:45.000'),
	 ('Catalogo de preguntas','catalogo_preguntas','Question','Catalogo de preguntas',NULL,'Catalogos','Catalogo de preguntas','2020-10-05 15:24:45.000','2020-10-05 15:24:45.000'),
	 ('Catalogo de respuestas','catalogo_respuestas','Answer','Catalogo de respuestas',NULL,'Catalogos','Catalogo de respuestas','2020-10-05 15:24:45.000','2020-10-05 15:24:45.000'),
	 ('Catalogo de servicios de mantenimiento','catalogo_servicios','ConceptService','Catalogo de servicios',NULL,'Catalogos','Catalogo de servicios','2020-10-05 15:24:45.000','2020-10-05 15:24:45.000')
;
EOL
sql.split(';').each do |s|                                        
  connection.execute(s.strip) unless s.strip.empty?
end
Permission.create(nombre: "Autorización de ordenes de compra", accion: "autorizacion_ordenes_compra", clase: "purchase_orders_request", descripcion: "Autorizar o rechazar ordenes de compra", menu: "Maestro de vehículos", opcion: "Autorización de ordenes de compra")