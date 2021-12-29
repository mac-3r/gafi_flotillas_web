class ConceptService < ApplicationRecord
    attr_accessor :seleccionado

    enum estatus: {"Activo": 0, "Inactivo":1}
end
