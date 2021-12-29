select to_char(i.fecha_ocurrio, 'MON') as mes, to_char(i.fecha_ocurrio, 'MM') as mes_numero, 
to_char(i.fecha_ocurrio, 'YYYY') as anio,
cb.decripcion as sucursal, cb.id as sucursal_id, sum(i.monto_siniestro) as costo, 
TO_DATE(CONCAT(to_char(i.fecha_ocurrio, 'YYYY') , '-' , to_char(i.fecha_ocurrio, 'MM') , '-01'),'YYYY-MM-DD') as fecha
from insurance_report_tickets i
inner join vehicles v on i.vehicle_id = v.id
inner join catalog_branches cb on v.catalog_branch_id = cb.id
where i.estatus = 2
group by mes, mes_numero, anio, fecha, sucursal_id ;