class Inventory
  include Mongoid::Document
  include Mongoid::Timestamps
  

  PRICING_TYPES = %w[% $ $$]

  field :ivt_id,                type: String
  field :name,                  type: String
  field :re_order_point,        type: String
  field :quantity,              type: Integer, default: 0
  field :purchase_date,         type: Date
  field :location,              type: String

  field :cost,                  type: Float
  field :price_type,            type: String

  field :notes,                 type: String
  
  belongs_to :member, class_name: "User"
  belongs_to :user
  belongs_to :property

  validates_presence_of :ivt_id, :name, :location, :cost, :price_type

  def self.search(search)
    if search.present?
      self.or({ :ivt_id => /.*#{search}*./ }, { :name => /.*#{search}*./ })
    else
      self
    end
  end

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

  def self.itv_list
    ivt_list = self.all.map(&:ivt_id).uniq
  end

  def self.count(ivt_id)
    inventories = self.where(ivt_id:ivt_id)
    inventories.map(&:quantity).sum
  end
end
