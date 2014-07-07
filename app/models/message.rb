class Message
  include Mongoid::Document
  include Mongoid::Timestamps
  
  field :username,          type: String
  field :email,             type: String
  field :subject,           type: String
  field :body,              type: String
  

  # Relationships
  belongs_to :sender, :class_name => 'User', :inverse_of => :messages_sent
  belongs_to :receiver, :class_name => 'User', :inverse_of => :messages_received


  belongs_to :thread, :class_name => 'Message'  # Reference to parent message
  has_many :replies,  :class_name => 'Message', :foreign_key => 'thread_id'

  
  scope :in_reply_to, lambda { |message| where({:thread => message}).asc('created_at') }
 
  #validations
  validates_presence_of :username, :email, :subject, :body, :sender, :receiver
  validates_length_of :subject, :within => 10..70
  validates_length_of :body, :within => 10..1000
 
end