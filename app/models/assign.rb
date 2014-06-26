class Assign
  include Mongoid::Document
  include Mongoid::Timestamps

  belongs_to :member, class_name: "User"
  belongs_to :property

end
