class FlightDecorator < Draper::Decorator

  delegate_all

  def description
    "Flight from #{departure_airport.full_name} #{departure_airport.name} to #{destination_airport.full_name} #{destination_airport.name}."
  end

  def dates
    "Departures at #{departure_date} and arrives at #{arrival_date}."
  end

  def current_price
    "Current price: #{price}."
  end

  def price
    price = prices.last
    price.normal.to_s + price.currency
  end

end
