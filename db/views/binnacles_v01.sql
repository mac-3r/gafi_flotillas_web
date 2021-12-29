select cd.id as id,       
cd.nombre as nombre,
cd.tipo_afinacion as tipo_afinacion,
cc.descripcion as categoria,
cc.id as concept_id,
cb.catalog_brand_id as catalog_brand_id, 
fc.frecuencia_reemplazo,
fc.frecuencia_inspeccion,
fc.tipo_frecuencia,
fc.meses,
fc.fecha
from concept_descriptions cd inner join concept_brands as cb on cd.id = cb.concept_description_id 
inner join concept_conceptdescriptions ccd on ccd.concept_description_id = cd.id 
inner join frequency_concepts as fc on cb.id = fc.concept_brand_id
inner join concepts cc on cc.id = ccd.concept_id
where cd.estatus and fc.estatus