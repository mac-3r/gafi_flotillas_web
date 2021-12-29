select to_char(i.fecha_ocurrio, 'MON') as mes, to_char(i.fecha_ocurrio, 'MM') as mes_numero,
i.tipo_siniestro as tipo_siniestro, i.type_sinisters_id as id_tipo_siniestro,
to_char(i.fecha_ocurrio, 'YYYY') as anio,
cb.decripcion as sucursal, cb.id as sucursal_id, 
count((select irt.responsable as id_dist from insurance_report_tickets irt where irt.responsable = i.responsable group by irt.responsable)) as total_siniestros,
i.responsable as responsable ,
i.catalog_area_id as catalog_area_id,
TO_DATE(CONCAT(to_char(i.fecha_ocurrio, 'YYYY') , '-' , to_char(i.fecha_ocurrio, 'MM') , '-01'),'YYYY-MM-DD') as fecha
from insurance_report_tickets i
inner join vehicles v on i.vehicle_id = v.id
inner join catalog_branches cb on v.catalog_branch_id = cb.id
group by mes, mes_numero, anio, fecha, sucursal_id, responsable, tipo_siniestro, id_tipo_siniestro, i.catalog_area_id ;