select to_char(i.fecha_ocurrio, 'MON') as mes, to_char(i.fecha_ocurrio, 'MM') as mes_numero, 
to_char(i.fecha_ocurrio, 'YYYY') as anio,
cc.nombre as nombre_empresa,
cc.id as id_empresa,
i.id as id_ticket,
i.cedis as sucursal, cb.id as sucursal_id,
i.estatus_responsabilidad_gafi as respon_gafi,
TO_DATE(CONCAT(to_char(i.fecha_ocurrio, 'YYYY') , '-' , to_char(i.fecha_ocurrio, 'MM') , '-', to_char(i.fecha_ocurrio, 'DD')),'YYYY-MM-DD') as fecha
from insurance_report_tickets i
inner join vehicles v on i.vehicle_id = v.id
inner join catalog_branches cb on v.catalog_branch_id = cb.id
inner join catalog_companies cc on cc.id = cb.id
group by mes, mes_numero, anio, fecha,i.cedis, sucursal_id , id_empresa, nombre_empresa, id_ticket, respon_gafi;