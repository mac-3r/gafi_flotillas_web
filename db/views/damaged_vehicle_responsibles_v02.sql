select 
i.numero_economico as num_economico,
sum(i.monto_siniestro) as monto_sin,
cb.decripcion as sucursal, cb.id as sucursal_id, 
cc.id as id_empresa, cc.nombre as nombre_empresa,
count((select irt.responsable as id_dist from insurance_report_tickets irt where irt.responsable = i.responsable group by irt.responsable)) as total_siniestros,
i.responsable as responsable ,
TO_DATE(CONCAT(to_char(i.fecha_ocurrio, 'YYYY') , '-' , to_char(i.fecha_ocurrio, 'MM'), '-' , to_char(i.fecha_ocurrio, 'DD')),'YYYY-MM-DD') as fecha
from insurance_report_tickets i
inner join vehicles v on i.vehicle_id = v.id
inner join catalog_branches cb on v.catalog_branch_id = cb.id
inner join catalog_companies cc on cc.id = cb.catalog_company_id 
group by 
cc.id, cc.nombre, sucursal_id, fecha, responsable, num_economico  