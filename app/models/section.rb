class Section < ApplicationRecord
    has_many :catalog_areas_sections

    def get_status
        return self.status ? "Activo" : "Inactivo"
    end

    def self.consultas_autorizacion_card(budget_id, section_id)
        seccion = CatalogAreasSection.where(section_id: section_id)
        conceptos = BudgetItem.where(catalog_area_id: seccion.map{|x|x.catalog_area_id}, budget_id: budget_id, estatus_autorizacion: "Por autorizar")
        if conceptos.length > 0
            bandera_mostrar = true
            cantidad = 0
            total = 0
            conceptos.each do |concepto|
                cantidad += concepto.cantidad
                total += (concepto.importe + concepto.plaqueo + concepto.seguro)
            end
        else
            bandera_mostrar = false
            cantidad = 0
            total = 0
        end 
        return bandera_mostrar, cantidad, total
    end
end
