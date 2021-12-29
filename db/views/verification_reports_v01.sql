select 
v.numero_economico as numero_economico,
cb.descripcion as tipo_vehiculo,
ca.descripcion as area_vehiculo,
cb2.decripcion as cedis_vehiculo,
bv.motivo as falla_encontrada,
bv.fecha_captura as fecha_auditoria,
vc.clasificacionvehiculo as tipo_reparacion,
bd.estatus as estatus,
cp.nombre as atiende
from bimonthly_details bd 
inner join bimonthly_verifications bv on bd.bimonthly_verification_id = bv.id
inner join vehicles v on bv.vehicle_id = v.id 
inner join catalog_personals cp on bv.catalog_personal_id = cp.id 
inner join catalog_brands cb on cb.id = v.catalog_brand_id 
inner join catalog_areas ca on ca.id = v.catalog_area_id 
inner join catalog_branches cb2 on cb2.id = v.catalog_branch_id 
inner join vehicle_checklists vc on vc.id = bd.vehicle_checklist_id 
