select cd.id as id, 
cd.nombre as nombre,
cd.clave as clave,
cd.tipo_afinacion as tipo_afinacion,
cc.descripcion as categoria,
cc.id as id_categoria
from concept_descriptions cd 
inner join concept_conceptdescriptions ccd on ccd.concept_description_id = cd.id
inner join concepts cc on cc.id = ccd.concept_id
where cd.estatus 
;
