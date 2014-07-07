class Property
  include Mongoid::Document
  include Mongoid::Timestamps
  
  field :name,                    :type => String
  field :pt_id,                   :type => String
  field :address1,                :type => String
  field :address2,                :type => String
  field :city,                    :type => String
  field :state,                   :type => String
  field :zip_code,                :type => String
  field :phone,                   :type => String
  
  field :bedrooms,                :type => Integer
  field :full_bathrooms,          :type => Integer
  field :half_bathrooms,          :type => Integer

  field :notes,                   :type => String

  belongs_to :owner
  belongs_to :user
  has_many :property_locations
  has_many :assigns
  has_many :inventory_requests
  
  validates_presence_of :name, :pt_id, :address1, :city, :state, :phone
  validates_uniqueness_of :pt_id

  def location
    [address1, city, state, zip_code].join(", ")
  end

  def cleaner_inspector_name
    assign = assigns.first
    if assign.present?
      assign.member.name
    else
      "Not assigned"
    end
  end

  def assign_status
    assign = assigns.first
    if assign.present?
      assign.status
    else
      "Not assigned"
    end    
  end

  def assigned_last_sign_in_at
    assign = assigns.first
    if assign.present?
      assign.member.last_sign_in_at
    else
      "Not assigned"
    end
  end

  def self.search(search)
    if search.present?
      where({ :name => /.*#{search}*./ })
    else
      self
    end
  end
end