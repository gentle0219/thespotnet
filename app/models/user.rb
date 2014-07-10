class User
  include Mongoid::Document
  include Mongoid::Timestamps
  
  ROLES = ['cleaner', 'inspector', 'maintenance', 'guest', 'admin', 'manager']
  
  MANAGER_ROLES = ['guest', 'cleaner', 'inspector', 'maintenance']
  mount_uploader :avatar, AvatarUploader
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :token_authenticatable
         
  ## Database authenticatable
  field :email,                     :type => String, :default => ""
  field :name,                      :type => String, :default => ""
  field :phone,                     :type => String, :default => ""
  field :encrypted_password,        :type => String, :default => ""

  
  field :country_code,              :type => String

  field :confirmed_value,           :type => String, :default => ""

  ## Recoverable
  field :reset_password_token,      :type => String
  field :reset_password_sent_at,    :type => Time

  ## Rememberable
  field :remember_created_at,       :type => Time

  ## Trackable
  field :sign_in_count,             :type => Integer, :default => 0
  field :current_sign_in_at,        :type => Time
  field :last_sign_in_at,           :type => Time
  field :current_sign_in_ip,        :type => String
  field :last_sign_in_ip,           :type => String

  ## Confirmable
  # field :confirmation_token,      :type => String
  # field :confirmed_at,            :type => Time
  # field :confirmation_sent_at,    :type => Time
  # field :unconfirmed_email,       :type => String # Only if using reconfirmable

  ## Lockable
  # field :failed_attempts,         :type => Integer, :default => 0 # Only if lock strategy is :failed_attempts
  # field :unlock_token,            :type => String # Only if unlock strategy is :email or :both
  # field :locked_at,               :type => Time

  field :role,                      :type => String,    :default => "cleaner"

  field :authentication_token,      :type => String
  
  before_save :ensure_authentication_token
  
  belongs_to :manager, :class_name => "User"
  has_many :members, :class_name => "User", :foreign_key=>"manager_id", :dependent => :destroy
  
  # belongs_to :admin, :class_name => "User"
  # has_many :managers, :class_name => "User", :foreign_key=>"admin_id", :dependent => :destroy


  has_many :devices
  has_many :properties
  has_many :work_orders
  has_many :inventories
  has_many :inventory_requests
  has_many :lost_founds


  has_many :sent_messages, class_name: "Message", foreign_key: 'sender_id'
  has_many :received_messages, class_name: "Message", foreign_key: 'receiver_id'
  # has_many :conversations


  scope :cleaners, -> {where(role:User::MANAGER_ROLES[1])}
  scope :inspectors, -> {where(role:User::MANAGER_ROLES[2])}
  scope :maintenances, -> {where(role:User::MANAGER_ROLES[3])}



  validates_presence_of :role
  
  def device_id
    devices.first.dev_id if devices.present?
  end

  def unread_messages
    received_messages.where(read: false).order_by('created_at DESC')
  end
  def get_role_list
    role_list = User::MANAGER_ROLES
    if self.role == User::ROLES[4]          # if admin
      role_list << 'manager'
    elsif self.role == User::ROLES[5]       # if manager
      role_list
    else
      ["",""]
    end
  end

  def is_admin?
    self.role == User::ROLES[4]
  end

  def role_of_number
    User::MANAGER_ROLES.index(role)
  end

  def is_manager?
    self.role == User::ROLES[5]
  end
  # def all_user_list
  #   manager_list = []
  #   if self.role == User::ROLES[4]          # if admin
  #     members = self.members

  #   else
  #     manager_list
  #   end
  # end
  
  def inventory_requests
    if is_manager?
      user_ids = members.map(&:id)
      InventoryRequest.in(user_id:user_ids)
    else
      []
    end
  end
  
  def property_locations
    p_ids = properties.map(&:id)
    PropertyLocation.in(property_id:p_ids)
  end
  
  def conversations
    Conversation.in(participant_ids:self.id)
  end

  def self.find_by_token token
    where(authentication_token:token).first
  end

  def self.all_search(search)
    search.present? ? User.or({ :email => /.*#{search}*./ }, { :name => /.*#{search}*./ }) : User.all    
  end

  def self.search(search)
    if search.present?
      self.or({ :email => /.*#{search}*./ }, { :name => /.*#{search}*./ })
    else
      self
    end
  end  
end
