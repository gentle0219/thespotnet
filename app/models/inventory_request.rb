class InventoryRequest
  include Mongoid::Document
  include Mongoid::Timestamps
  
  field :ivt_id,                type: String
  field :quantity,              type: Integer, default: 0
  field :sent_date,             type: DateTime
  field :accept_date,           type: DateTime

  field :state,                 type: Float
    
  belongs_to :user
  
  validates_presence_of :ivt_id, :quantity, :user_id

end
