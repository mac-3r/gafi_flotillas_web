select irt.cedis as cedis, cb2.id as id_cedis, 
sum(irt.monto_siniestro) as monto_sin,
cc.id as id_empresa, cc.nombre as nombre_empresa,
TO_DATE(CONCAT(to_char(irt.fecha_ocurrio, 'YYYY') , '-' , to_char(irt.fecha_ocurrio, 'MM'), '-' , to_char(irt.fecha_ocurrio, 'DD')),'YYYY-MM-DD') as fecha,
(select count(distinct(irt2.vehicle_id)) as numecon from insurance_report_tickets irt2
where irt2.cedis = irt.cedis
) as vehiculos_daniados,
(select count(*) from vehicles v2 
inner join catalog_branches cb on cb.id = v2.catalog_branch_id
where cb.decripcion = cedis ) as total_vehiculos,
(NULLIF(((select count(distinct(irt2.vehicle_id)) as numecon from insurance_report_tickets irt2
where irt2.cedis = irt.cedis
) * 100), 0) / NULLIF((select count(*) from vehicles v2 
inner join catalog_branches cb on cb.id = v2.catalog_branch_id
where cb.decripcion = cedis ), 0)) as porcentaje,
irt.vehicle_id as vehicle_id,
irt.catalog_area_id as catalog_area_id
from insurance_report_tickets irt
inner join catalog_branches cb2 on cb2.decripcion = cedis
inner join catalog_companies cc on cc.id = cb2.catalog_company_id 
group by 
cc.id, cc.nombre, 
cedis, id_cedis, fecha, irt.catalog_area_id, irt.vehicle_id