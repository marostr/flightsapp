module FlightAbstractFactory
	def create(user,departure_airport,arrival_airport,departure_date)
		raise NotImplementedError, "Not implemented error"
	end
end

class FlightFactory
	include FlightAbstractFactory
	def create(user,departure_airport,arrival_airport,departure_date)
		
	end
end
