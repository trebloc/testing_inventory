class Product < ActiveRecord::Base
	#If new product attributes is nil, validate that attributes exist. Validation lives in the model (AR Validation)
  validates :name, :description, :category, :sku, :wholesale, :retail, presence: true

  def margin
    (retail - wholesale) / retail
  end	
end
