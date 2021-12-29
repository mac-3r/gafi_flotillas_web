class Customer < ApplicationRecord
  belongs_to :catalog_branch
  belongs_to :catalog_company
  #has_many :vehicle_consumption
  has_many :delivery_addresses
  def self.listado_clientes
    Customer.all
  end
end
