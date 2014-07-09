class WorkOrder
  include Mongoid::Document
  include Mongoid::Timestamps

  STATUS=%w[OPEN CLOSED IMPORTANT]
  LEVELS = %w[Priority Low Medium High]
  VIEW_LEVELS = %w[All Opend Closed Important]
  field :title,                     :type => String
  field :details,                   :type => String
  field :location,                  :type => String
  field :level,                     :type => String
  field :opend,                     :type => Boolean, default: true

  belongs_to :maintenance,  class_name: 'User'

  belongs_to :category
  belongs_to :member,       class_name: 'User'
  belongs_to :user
  belongs_to :property

  validates_presence_of :title, :details, :property

  def unit_id
    if property.present?
      property.pt_id
    else
      ''
    end
  end

  def unit_name
    if property.present?
      property.name
    else
      ''
    end
  end

  def vendor_name
    if maintenance.present?
      maintenance.name
    else
      ''
    end    
  end

  def user_name
    user.name if user.present?
  end
  def member_name
    member.name if member.present?
  end
end
