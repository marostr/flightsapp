class FlightFactory < FlightAbstractFactory
  attr_accessor :user, :departure_airport, :destination_airport, :date, :flight, :response

  def initialize(user, departure_airport, destination_airport, date)
    @user = user
    @departure_airport = departure_airport
    @destination_airport = destination_airport
    @date = date
    @flight = Flight.new
  end

  def create
    @response = price_fetcher.call
    if response.success?
      create_or_find_airports
      create_flight
      update_price
    end
    flight
  end

  private

  def create_or_find_airports
    @departure_airport = Airport.where(name: departure_airport).first_or_create
    @destination_airport = Airport.where(name: destination_airport).first_or_create
  end

  def create_flight
    flight.user = user
    flight.departure_airport = departure_airport
    flight.destination_airport = destination_airport
    flight.departure_date = response.body[:departure_date]
    flight.arrival_date = response.body[:arrival_date]
  end

  def update_price
    updater = PriceUpdater.new(flight, response.body[:price], response.body[:currency])
    updater.call!
  end

  def price_fetcher
    @price_fetcher ||= Wizzair::Fetchers::Price.new(departure_airport, destination_airport, date)
  end

end
