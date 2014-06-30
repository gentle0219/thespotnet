class Category
  include Mongoid::Document
  
  field :name,              type: String
  field :active,            type: Boolean, default:false
  field :order_id,          type: Integer
  
  belongs_to :parent, :class_name => "Category"
  has_many :subcategories, :class_name => "Category", :foreign_key=>"parent_id", :dependent => :destroy, :order=> "order_id ASC"
  
  has_many :work_orders
end
