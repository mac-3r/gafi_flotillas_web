select irt.cedis as cedis, cb2.id as id_cedis,
TO_DATE(CONCAT(to_char(irt.fecha_ocurrio, 'YYYY') , '-' , to_char(irt.fecha_ocurrio, 'MM'), '-' , to_char(irt.fecha_ocurrio, 'DD')),'YYYY-MM-DD') as fecha,
(select count(distinct(irt2.vehicle_id)) as numecon from insurance_report_tickets irt2
where irt2.cedis = irt.cedis and irt2.estatus = 2
) as vehiculos_daniados,
(select count(*) from vehicles v2 
inner join catalog_branches cb on cb.id = v2.catalog_branch_id
where cb.decripcion = cedis ) as total_vehiculos,
(((select count(distinct(irt2.vehicle_id)) as numecon from insurance_report_tickets irt2
where irt2.cedis = irt.cedis and irt2.estatus = 2
) * 100) / (select count(*) from vehicles v2 
inner join catalog_branches cb on cb.id = v2.catalog_branch_id
where cb.decripcion = cedis )) as porcentaje
from insurance_report_tickets irt
inner join catalog_branches cb2 on cb2.decripcion = cedis
group by cedis, id_cedis, fecha