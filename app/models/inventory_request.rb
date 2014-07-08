class InventoryRequest
  include Mongoid::Document
  include Mongoid::Timestamps
  
  field :ivt_id,                type: String
  field :quantity,              type: Integer, default: 0
  field :location,              type: String
  field :sent_date,             type: DateTime, default: Time.now
  field :accept_date,           type: DateTime

  field :accepted,              type: Boolean, default: false
    
  belongs_to :user
  belongs_to :property
  
  validates_presence_of :ivt_id, :quantity, :user_id


end
