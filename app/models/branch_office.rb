class BranchOffice < ApplicationRecord
  belongs_to :catalog_company
  has_many :vehicles
  def self.listado_centrosDis
    BranchOffice.where(status:true)
  end
end
