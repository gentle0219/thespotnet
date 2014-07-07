class PropertyLocation
	include Mongoid::Document
	
	field :location, :type => String

	belongs_to :property


end
