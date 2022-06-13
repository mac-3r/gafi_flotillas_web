json.encabezado @encabezado.each do  |e|
    json.id e.id
    folios = ""
    @folios.each do |f|
        if f.catalog_vendor_id == e.catalog_vendor_id && f.catalog_branch_id == e.catalog_branch_id && f.semana == e.semana && f.estatus == e.estatus && e.fecha_inicio == f.fecha_inicio && e.fecha_fin == f.fecha_fin
            folios = folios + f.folio.to_s + " " 
        end
    end
     json.folio folios
     json.fecha_inicio e.fecha_inicio
     json.fecha_fin e.fecha_fin
    json.cargas  Consumption.cargas_semana(e)
    # json.factura e.factura
    # json.monto e.monto
    json.cedis e.catalog_branch.decripcion
    json.semana e.semana
    
    json.monto Consumption.monto_semana(e)
     if  e.estatus == "Por autorizar"
         json.estatus_numero 1
     elsif  e.estatus == "Autorizado"   
         json.estatus_numero 2
     elsif e.estatus ==  "Rechazado"
         json.estatus_numero 3
     end 
     json.estatus e.estatus
    # json.created_at e.created_at
    # json.updated_at e.updated_at
    # json.n_factura e.n_factura
    # json.pdf e.pdf
     json.catalog_branch_id e.catalog_branch_id
     json.catalog_vendor_id e.catalog_vendor_id
end