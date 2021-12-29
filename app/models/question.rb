class Question < ApplicationRecord
    enum estatus: {"Activo": 0, "Inactivo":1}
end
