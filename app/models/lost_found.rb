class LostFound
  include Mongoid::Document
  include Mongoid::Timestamps
  
  
  field :item_name,                   type: String
  field :description,                 type: String
  
  belongs_to :user
  belongs_to :property

  validates_presence_of :item_name, :description, :user_id
end
