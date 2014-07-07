class Inventory
  include Mongoid::Document
  include Mongoid::Timestamps
  

  PRICING_TYPES = %w[% $ $$]

  field :ivt_id,                type: String
  field :name,                  type: String
  field :re_order_point,        type: String
  field :quantity,              type: Integer
  field :purchase_date,         type: Date
  field :location,              type: String

  field :cost,                  type: Float
  field :price_type,            type: String

  field :notes,                 type: String
  
  belongs_to :member, class_name: "User"
  belongs_to :user
  belongs_to :property

  validates_presence_of :ivt_id, :name, :location, :cost, :price_type
  
  def selling_price
    case price_type
    when Inventory::PRICING_TYPES[0]
      (cost / 100.0) + 100
    when Inventory::PRICING_TYPES[1]
      cost + 15
    when Inventory::PRICING_TYPES[2]
      cost
    end
  end
end
