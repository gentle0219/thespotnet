class Device
  include Mongoid::Document
  include Mongoid::Timestamps

  DEVICE_PLATFORM=%w[ios android]

  field :dev_id,          :type => String  
  field :platform,        :type => String,    default: 'android'
  field :badge_count,     :type => Integer,   default: 0
  
  belongs_to :user  

  validates_uniqueness_of :dev_id, :scope => :user_id

end
