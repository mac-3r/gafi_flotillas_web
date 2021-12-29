select irt.cedis as cedis, cb2.id as id_cedis, 
irt.monto_siniestro as monto_sin,
cc.id as id_empresa, cc.nombre as nombre_empresa,
irt.numero_economico as num_economico,
TO_DATE(CONCAT(to_char(irt.fecha_ocurrio, 'YYYY') , '-' , to_char(irt.fecha_ocurrio, 'MM'), '-' , to_char(irt.fecha_ocurrio, 'DD')),'YYYY-MM-DD') as fecha
from insurance_report_tickets irt
inner join catalog_branches cb2 on cb2.decripcion = cedis
inner join catalog_companies cc on cc.id = cb2.catalog_company_id 
group by numero_economico,
cc.id, cc.nombre, monto_sin,
cedis, id_cedis, fecha