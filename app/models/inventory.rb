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
  belongs_to :property

end
