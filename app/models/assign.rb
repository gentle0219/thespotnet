class Assign
  include Mongoid::Document
  include Mongoid::Timestamps
  
  STATUS_TYPE = %w[ONSITE LEFT COMPLETE]

  field :status,          type: String,       default: Assign::STATUS_TYPE[0]
  
  belongs_to :member, class_name: "User"
  belongs_to :property

end
