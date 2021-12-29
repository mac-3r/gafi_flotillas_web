class CatalogConsideration < ApplicationRecord
  belongs_to :catalog_brand
  validates :clave,:descripcion, presence: true
end
