class Reason < ApplicationRecord
    has_many :budget_details
    has_many :budget_distibutions
    has_many :budget_sales_replacements
    validates :descripcion, presence: true

    def self.listado_motivos
        Reason.all.order(descripcion: :asc)
    end

end
