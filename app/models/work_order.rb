class WorkOrder
  include Mongoid::Document
  include Mongoid::Timestamps

  STATUS=%w[OPEN CLOSED IMPORTANT]

  field :title,                     :type => String
  field :details,                   :type => String
  field :location,                  :type => String
  
  belongs_to :property
  belongs_to :category
  belongs_to :member,       class_name: 'User'
  belongs_to :user

  validates_presence_of :location, :title, :details

  def member_name
    member.name if member.present?
  end
end
