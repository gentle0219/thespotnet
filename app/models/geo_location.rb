class GeoLocation
	include Mongoid::Document
	include Geocoder::Model::Mongoid
	
	field :address, :type => String
	field :coordinates, :type => Array

	geocoded_by :address, :skip_index => true
	#reverse_geocoded_by :coordinates
	
	after_validation :geocode          # auto-fetch coordinates

	belongs_to :property

	def distance(to_geo)
		Geocoder::Calculations.distance_between(self.coordinates, to_geo.coordinates)
	end

end
