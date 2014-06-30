class WorkOrder
  include Mongoid::Document
  include Mongoid::Timestamps

  STATUS=%w[OPEN CLOSED IMPORTANT]

  field :title,                   :type => String
  field :details,                   :type => String
  
  belongs_to :property
  belongs_to :category
  belongs_to :member,       class_name: 'User'
  belongs_to :user
end
