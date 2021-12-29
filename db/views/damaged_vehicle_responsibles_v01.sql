select 
i.numero_economico as num_economico,
cb.decripcion as sucursal, cb.id as sucursal_id, 
count((select irt.responsable as id_dist from insurance_report_tickets irt where irt.responsable = i.responsable group by irt.responsable)) as total_siniestros,
i.responsable as responsable ,
TO_DATE(CONCAT(to_char(i.fecha_ocurrio, 'YYYY') , '-' , to_char(i.fecha_ocurrio, 'MM') , '-01'),'YYYY-MM-DD') as fecha
from insurance_report_tickets i
inner join vehicles v on i.vehicle_id = v.id
inner join catalog_branches cb on v.catalog_branch_id = cb.id
where i.estatus = 2
group by sucursal_id, fecha_ocurrio, responsable, num_economico  ;