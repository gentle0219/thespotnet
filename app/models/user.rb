class User
  include Mongoid::Document
  include Mongoid::Timestamps

  ROLES = ['cleaner', 'inspector', 'maintenance', 'guest', 'admin', 'manager']
  
  MANAGER_ROLES = ['cleaner', 'inspector', 'maintenance', 'guest']
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
  
  has_many :properties
  
  validates_presence_of :role

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
