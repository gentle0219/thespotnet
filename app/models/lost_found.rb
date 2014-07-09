class LostFound
  include Mongoid::Document
  include Mongoid::Timestamps
  
  
  field :item_name,                   type: String
  field :description,                 type: String
  field :lost,                        type: Boolean, default: true

  belongs_to :user  # property manager or cleaner, inspector
  belongs_to :property

  validates_presence_of :item_name, :description, :user_id

  scope :lost_items, -> {where(lost: true)}


end
