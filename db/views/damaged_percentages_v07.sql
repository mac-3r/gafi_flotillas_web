select to_char(i.fecha_ocurrio, 'MON') as mes, to_char(i.fecha_ocurrio, 'MM') as mes_numero, 
to_char(i.fecha_ocurrio, 'YYYY') as anio,
cc.nombre as nombre_empresa,
cc.id as id_empresa,
i.cedis as sucursal, cb.id as sucursal_id, sum(i.monto_siniestro) as costo, 
i.catalog_area_id as catalog_area_id,
i.vehicle_id as vehicle_id,
TO_DATE(CONCAT(to_char(i.fecha_ocurrio, 'YYYY') , '-' , to_char(i.fecha_ocurrio, 'MM') , '-', to_char(i.fecha_ocurrio, 'DD')),'YYYY-MM-DD') as fecha
from insurance_report_tickets i
inner join vehicles v on i.vehicle_id = v.id
inner join catalog_branches cb on v.catalog_branch_id = cb.id
inner join catalog_companies cc on cc.id = cb.catalog_company_id 
group by mes, mes_numero, anio, fecha, sucursal_id,sucursal, id_empresa, nombre_empresa, i.catalog_area_id, i.vehicle_id ;