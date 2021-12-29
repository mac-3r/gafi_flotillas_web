				
SELECT catalog_brands.id as catalog_brand_id,concepts.id as concept_id,bujias as bujias,
frequency_concepts.id, concept_descriptions.nombre, concepts.descripcion,concepts.descripcion as categoria,catalog_brands.descripcion as linea,concept_descriptions.tipo_afinacion as tipo_afinacion,frequency_concepts.tipo_frecuencia as tipo_frecuencia,frequency_concepts.frecuencia_inspeccion,frequency_concepts.frecuencia_reemplazo,frequency_concepts.meses,frequency_concepts.fecha FROM frequency_concepts
				INNER JOIN catalog_brands ON catalog_brands.id = frequency_concepts.catalog_brand_id 
				INNER JOIN concept_brands ON concept_brands.id = frequency_concepts.concept_brand_id 
				INNER JOIN concept_descriptions ON concept_descriptions.id = concept_brands.concept_description_id
				INNER JOIN concept_conceptdescriptions on concept_conceptdescriptions.concept_description_id = concept_descriptions.id
				inner join concepts on concepts.id = concept_conceptdescriptions.concept_id
				WHERE frequency_concepts.estatus = true 
				
				