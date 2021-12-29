select v.*,
coalesce((select cc.nombre from catalog_companies cc where cc.id = v.catalog_company_id), 'No se asignó') as company,
coalesce((select cb.decripcion from catalog_branches cb where cb.id = v.catalog_branch_id), 'No se asignó') as branch,
coalesce((select cp.nombre from catalog_personals cp where cp.id = v.catalog_personal_id), 'No se asignó') as personal,
coalesce((select vt.descripcion from vehicle_types vt where vt.id = v.vehicle_type_id), 'No se asignó') as vehicle_type,
coalesce((select cb2.descripcion from catalog_brands cb2 where cb2.id = v.catalog_brand_id), 'No se asignó') as brand,
coalesce((select cm.descripcion from catalog_models cm where cm.id = v.catalog_model_id), 'No se asignó') as model,
coalesce((select ca.descripcion from catalog_areas ca where ca.id = v.catalog_area_id), 'No se asignó') as catalog_area
from vehicles v