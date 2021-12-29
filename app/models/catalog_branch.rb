class CatalogBranch < ApplicationRecord
  belongs_to :catalog_company
  has_many :consumptions
  has_many :catalog_responsives
  has_many :accounting_impacts
  has_many :perform_targets
  has_many :vehicles
  has_many :competition_tables
  has_many :cost_centers
  has_many :budget_concepts
  has_many :budget_distibutions
  has_many :budget_item
  has_many :budget_sales_replacements
  has_many :customers
  has_many :delivery_addresses
  has_many :catalog_workshops
  has_many :monthly_yields
  has_many :tuning_prices
  has_many :expense_vehicle_types
  has_many :catalog_branches_users
  has_many :purchase_orders
  has_and_belongs_to_many :users
  has_many :service_orders
  has_many :valuations_branches

  validates :decripcion, uniqueness: true
  validates :clave_jd,:clave,:unidad_negocio,:abreviacion,:decripcion, presence: true
  validates :abreviacion, length: { maximum: 3 }


  def self.listado_cedis
    CatalogBranch.where(status:true).order(decripcion: :asc)
  end

  def get_status
    return self.status ? "Activo" : "Inactivo"
  end

  def cedis_empresa
    "#{self.catalog_company.nombre}.- #{self.decripcion}"
  end
  
end
