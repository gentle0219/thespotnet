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

  belongs_to :geo_location

  belongs_to :owner
  belongs_to :user
  
  validates_presence_of :name, :pt_id, :address1, :city, :state, :phone
  validates_uniqueness_of :pt_id

  def location
    'location'
  end



  def self.search(search)
    if search.present?
      where({ :name => /.*#{search}*./ })
    else
      self
    end
  end
end