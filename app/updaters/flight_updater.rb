class FlightUpdater
  attr_accessor :flight, :response
  
  def initialize(flight)
    @flight = flight    
  end
  
  def call!
    @response = price_fetcher.call
    if response.success?
      update_price
    end
    flight
  end


  private

  def update_price
    updater = PriceUpdater.new(flight, response.body[:price], response.body[:currency])
    updater.call!
  end

  def price_fetcher
    @price_fetcher ||= Wizzair::Fetchers::Price.new(departure_airport, destination_airport, date)
  end  

  def destination_airport
    flight.destination_airport.name
  end
  
  def departure_airport
    flight.departure_airport.name
  end

  def date
    flight.departure_date
  end

  
end

